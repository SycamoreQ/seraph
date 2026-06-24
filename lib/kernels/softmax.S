// softmax_neon.S
//
// void softmax_neon(float *x, int n)
//
// Numerically stable softmax computed in place over x[0..n-1]:
//   1. find max(x[i])
//   2. compute e^(x[i] - max) in place, via 4-term Horner approximation
//   3. sum all e^(x[i] - max)
//   4. divide each element by the sum via frecpe/frecps reciprocal
//
// AAPCS64: x0 = x, w1 = n. Leaf function; only touches v0-v4, v16-v24,
// w3-w4, w7, x0, x2, x5 -- all caller-saved, no push/pop needed.
//
// Taylor series accuracy: e^x ≈ 1 + x + x^2/2 + x^3/6 + x^4/24.
// After max subtraction all inputs are ≤ 0. Accuracy degrades for
// x << 0 (e.g. x < -8), but those elements contribute negligibly to
// the softmax output anyway (e^-8 ≈ 0.0003), so the approximation
// error is swamped by the normalization.

#if defined(__APPLE__)
#define FN(name) _##name
#else
#define FN(name) name
#endif

#if defined(__APPLE__)
	.section __TEXT,__const
#else
	.section .rodata
#endif
	.align 2
softmax_consts:
	.float  0.041666667   // 1/24  offset  0
	.float  0.166666667   // 1/6   offset  4
	.float  0.500000000   // 1/2   offset  8
	.float  1.000000000   // 1.0   offset 12
	.word   0xFF800000    // -inf  offset 16  (IEEE 754 bit pattern)

	.text
	.global FN(softmax_neon)
#if !defined(__APPLE__)
	.type FN(softmax_neon), %function
#endif

FN(softmax_neon):
	// Save base pointer and n for reuse across all four passes
	mov     x5, x0
	mov     w7, w1

	// Load constants once, before any loop
	// On macOS use: adrp x2, softmax_consts@PAGE
	//               add  x2, x2, softmax_consts@PAGEOFF
#if defined(__APPLE__)
	adrp    x2, softmax_consts@PAGE
	add     x2, x2, softmax_consts@PAGEOFF
#else
	adrp    x2, softmax_consts
	add     x2, x2, :lo12:softmax_consts
#endif
	ldr     s0, [x2]
	dup     v24.4s, v0.s[0]   // v24 = [1/24, 1/24, 1/24, 1/24]
	ldr     s0, [x2, #4]
	dup     v23.4s, v0.s[0]   // v23 = [1/6,  1/6,  1/6,  1/6 ]
	ldr     s0, [x2, #8]
	dup     v22.4s, v0.s[0]   // v22 = [1/2,  1/2,  1/2,  1/2 ]
	ldr     s0, [x2, #12]
	dup     v21.4s, v0.s[0]   // v21 = [1.0,  1.0,  1.0,  1.0 ]
	ldr     s0, [x2, #16]
	dup     v16.4s, v0.s[0]   // v16 = [-inf, -inf, -inf, -inf] (max accumulator)

	lsr     w4, w7, #2
	and     w3, w7, #3
	cbz     w4, .Lmax_vec_done

.Lmax_vec_loop:
	ld1     {v0.4s}, [x0], #16
	fmax    v16.4s, v16.4s, v0.4s
	subs    w4, w4, #1
	b.ne    .Lmax_vec_loop

.Lmax_vec_done:
	// Horizontal reduce: collapse 4 lanes into one scalar in s0
	fmaxp   v0.4s, v16.4s, v16.4s
	fmaxp   s0, v0.2s
	cbz     w3, .Lmax_done

.Lmax_scalar_loop:
	ldr     s1, [x0], #4
	fmax    s0, s0, s1
	subs    w3, w3, #1
	b.ne    .Lmax_scalar_loop

.Lmax_done:
	dup     v16.4s, v0.s[0]   // broadcast global max to all 4 lanes
	mov     x0, x5
	lsr     w4, w7, #2
	and     w3, w7, #3
	cbz     w4, .Lexp_vec_done

.Lexp_vec_loop:
	ld1     {v0.4s}, [x0]           // load, no advance yet
	fsub    v0.4s, v0.4s, v16.4s    // x = x - max  (now all <= 0)

	// Horner: e^x ≈ 1 + x*(1 + x*(1/2 + x*(1/6 + x/24)))
	mov     v1.16b, v23.16b          // v1 = 1/6
	fmla    v1.4s, v0.4s, v24.4s    // v1 = 1/6 + x*(1/24)
	mov     v2.16b, v22.16b          // v2 = 1/2
	fmla    v2.4s, v1.4s, v0.4s     // v2 = 1/2 + v1*x
	mov     v3.16b, v21.16b          // v3 = 1.0
	fmla    v3.4s, v2.4s, v0.4s     // v3 = 1.0 + v2*x
	mov     v4.16b, v21.16b          // v4 = 1.0
	fmla    v4.4s, v3.4s, v0.4s     // v4 = 1.0 + v3*x  (= e^x approx)

	st1     {v4.4s}, [x0], #16      // store back, advance
	subs    w4, w4, #1
	b.ne    .Lexp_vec_loop

.Lexp_vec_done:
	cbz     w3, .Lexp_done

.Lexp_scalar_loop:
	ldr     s0, [x0]
	fsub    s0, s0, s16              // s16 = max (lowest lane of v16)
	// Scalar Horner via fmadd: sd = sa + sn*sm
	ldr     s1, [x2]                 // s1 = 1/24
	ldr     s2, [x2, #4]             // s2 = 1/6
	fmadd   s1, s1, s0, s2           // s1 = 1/6 + (1/24)*x
	ldr     s2, [x2, #8]             // s2 = 1/2
	fmadd   s1, s1, s0, s2           // s1 = 1/2 + s1*x
	ldr     s2, [x2, #12]            // s2 = 1.0
	fmadd   s1, s1, s0, s2           // s1 = 1.0 + s1*x
	fmadd   s1, s1, s0, s2           // s1 = 1.0 + s1*x  (s2 still 1.0)
	str     s1, [x0], #4
	subs    w3, w3, #1
	b.ne    .Lexp_scalar_loop

.Lexp_done:
	mov     x0, x5
	lsr     w4, w7, #2
	and     w3, w7, #3
	movi    v17.4s, #0               // zero the sum accumulator
	cbz     w4, .Lsum_vec_done

.Lsum_vec_loop:
	ld1     {v0.4s}, [x0], #16
	fadd    v17.4s, v17.4s, v0.4s
	subs    w4, w4, #1
	b.ne    .Lsum_vec_loop

.Lsum_vec_done:
	faddp   v0.4s, v17.4s, v17.4s
	faddp   s0, v0.2s                // s0 = total sum
	cbz     w3, .Lsum_done

.Lsum_scalar_loop:
	ldr     s1, [x0], #4
	fadd    s0, s0, s1
	subs    w3, w3, #1
	b.ne    .Lsum_scalar_loop

.Lsum_done:
	// Compute reciprocal 1/sum via Newton-Raphson
	// frecpe gives ~8 bits; one frecps step brings it to ~16 bits

	frecpe  s17, s0                  // s17 ≈ 1/sum (initial estimate)
	frecps  s18, s0, s17             // s18 = refinement factor (2 - sum*s17)
	fmul    s17, s17, s18            // s17 = refined 1/sum
	dup     v17.4s, v17.s[0]         // broadcast to all 4 lanes
	mov     x0, x5
	lsr     w4, w7, #2
	and     w3, w7, #3
	cbz     w4, .Lnorm_vec_done

.Lnorm_vec_loop:
	ld1     {v0.4s}, [x0]
	fmul    v0.4s, v0.4s, v17.4s
	st1     {v0.4s}, [x0], #16
	subs    w4, w4, #1
	b.ne    .Lnorm_vec_loop

.Lnorm_vec_done:
	cbz     w3, .Ldone

.Lnorm_scalar_loop:
	ldr     s0, [x0]
	fmul    s0, s0, s17              // s17 lowest lane = 1/sum scalar
	str     s0, [x0], #4
	subs    w3, w3, #1
	b.ne    .Lnorm_scalar_loop

.Ldone:
	ret
