// dot_neon.S
//
// void dot_neon(const float *x , float *y , int n )
//
// c[i] = a[i] * b[i] = a_i*b_i + a_i+1*b_i+1
//
// AAPCS64 argument registers for this signature:
// x0 = x
// x1 = y
// w2 = n
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
	.global FN(dot_neon)
#if !defined(__APPLE__)
	.type FN(dot_neon), %function
#endif


FN (dot_neon):
	movi    v4.4s, #0            // zero the accumulator -- once, before the loop
	mov     w3, w2               // similar to saxpy ->
	lsr     w4, w2, #2
	and     w3, w3, #3
	cbz     w4, .Ltail

.Lvec_loop:
	ld1     {v2.4s}, [x0], #16
	ld1     {v3.4s}, [x1], #16
	fmla    v4.4s, v2.4s, v3.4s   // fused multiply add, or elementwise multiplication
	subs    w4, w4, #1
	b.ne    .Lvec_loop

.Ltail:
	faddp   v4.4s, v4.4s, v4.4s    // reduce v4's 4 lanes down to a scalar
	faddp   s0, v4.2s              // s0 now holds the real partial sum
	cbz     w3, .Ldone             // skip the tail entirely if n was a multiple of 4

.Ltail_loop:
	ldr     s2, [x0], #4
	ldr     s3, [x1], #4
	fmadd   s0, s2, s3, s0         // s0 += s2*s3 -- accumulate into the return value
	subs    w3, w3, #1
	b.ne    .Ltail_loop

.Ldone:
	ret
