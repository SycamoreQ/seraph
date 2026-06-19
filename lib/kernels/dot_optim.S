/*

This is the optmized dot product assembly with different compile time optmized.
This is to compare it with the barebones version saxpy.S in the same directory.

*/

#if defined(__APPLE__)
#define FN(name) _##name
#else
#define FN(name) name
#endif

	.text
	.global FN(dot_optim)
#if !defined(__APPLE__)
	.type FN(dot_optim), %function
#endif

FN(dot_optim):
	movi    v4.4s, #0
	movi    v5.4s, #0
	movi    v6.4s, #0
	movi    v7.4s, #0
	mov     w3, w2
	lsr     w4, w3, #4
	and     w5, w3, #15
	cbz     w4, .Lmedium_setup

.Lmain_loop:
	ld1     {v16.4s, v17.4s, v18.4s, v19.4s}, [x0], #64
	ld1     {v20.4s, v21.4s, v22.4s, v23.4s}, [x1], #64
	fmla    v4.4s, v16.4s, v20.4s
	fmla    v5.4s, v17.4s, v21.4s
	fmla    v6.4s, v18.4s, v22.4s
	fmla    v7.4s, v19.4s, v23.4s
	subs    w4, w4, #1
	b.ne    .Lmain_loop

.Lmedium_setup:
	lsr     w6, w5, #2
	and     w3, w5, #3
	cbz     w6, .Lcombine

.Lmedium_loop:
	ld1     {v16.4s}, [x0], #16
	ld1     {v20.4s}, [x1], #16
	fmla    v4.4s, v16.4s, v20.4s
	subs    w6, w6, #1
	b.ne    .Lmedium_loop

.Lcombine:
	fadd    v4.4s, v4.4s, v5.4s
	fadd    v6.4s, v6.4s, v7.4s
	fadd    v4.4s, v4.4s, v6.4s
	faddp   v4.4s, v4.4s, v4.4s
	faddp   s0, v4.2s
	cbz     w3, .Ldone

.Lscalar_loop:
	ldr     s2, [x0], #4
	ldr     s3, [x1], #4
	fmadd   s0, s2, s3, s0
	subs    w3, w3, #1
	b.ne    .Lscalar_loop

.Ldone:
	ret
