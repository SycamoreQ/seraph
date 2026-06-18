// saxpy_neon.S
//
// void saxpy_neon(float a, const float *x, float *y, int n)
//
// y[i] = a * x[i] + y[i]   for i in [0, n)
//
// AAPCS64 argument registers for this signature:
//   s0 = a   (first FP/SIMD arg)
//   x0 = x   (first integer/pointer arg)
//   x1 = y   (second integer/pointer arg)
//   w2 = n   (third integer arg, 32-bit)
//
// This is a leaf function and only touches v0-v3, w2-w4, x0-x1 — all of
// which are caller-saved under AAPCS64, so no register save/restore is
// needed here.
//
// .S (capital S) is preprocessed by the C preprocessor before assembly,
// which is what makes the FN() macro below work — on macOS/Mach-O, C
// symbols need a leading underscore; on Linux/ELF they don't.

#if defined(__APPLE__)
#define FN(name) _##name
#else
#define FN(name) name
#endif

	.text
	.global FN(saxpy_neon)
#if !defined(__APPLE__)
	.type FN(saxpy_neon), %function
#endif

FN(saxpy_neon):
	dup     v1.4s, v0.s[0]      // broadcast a into all 4 lanes -> v1
	mov     w3, w2              // w3 = n
	lsr     w4, w3, #2          // w4 = n / 4   (number of 4-wide iterations)
	and     w3, w3, #3          // w3 = n % 4   (tail count)
	cbz     w4, .Ltail

.Lvec_loop:
	ld1     {v2.4s}, [x0], #16  // load 4 floats from x, advance x0 by 16 bytes
	ld1     {v3.4s}, [x1]       // load 4 floats from y (no advance yet)
	fmla    v3.4s, v1.4s, v2.4s // v3 = v3 + a*v2   (fused multiply-add)
	st1     {v3.4s}, [x1], #16  // store result back to y, advance x1
	subs    w4, w4, #1
	b.ne    .Lvec_loop

.Ltail:
	cbz     w3, .Ldone

.Ltail_loop:
	ldr     s2, [x0], #4
	ldr     s3, [x1]
	fmadd   s3, s0, s2, s3      // s3 = a*s2 + s3   (scalar fused multiply-add)
	str     s3, [x1], #4
	subs    w3, w3, #1
	b.ne    .Ltail_loop

.Ldone:
	ret
