/*

This is the optimized saxpy assembly with different compile time optimizations. This
is to compare it with the barebones version saxpy.S in the same directory.

*/


#if defined(__APPLE__)
#define FN(name) _##name
#else
#define FN(name) name
#endif

	.text
	.global FN(saxpy_optim)
#if !defined(__APPLE__)
	.type FN(saxpy_optim), %function
#endif


FN(saxpy_optim):
	dup     v1.4s, v0.s[0]
	mov     w3, w2
	lsr     w4, w3, #4
	and     w5, w3, #15
	cbz     w4, .Lmedium_setup

.Lmain_Loop
    ld1     {v2.4s v3.4s v4.4s v5.4s}, [x0] , #64           // load into 4 vector regs, offset of 64
    ld1     {v6.4s v7.4s v8.4s v9.4s}, [x1]
    fmla    v6.4s, v2.4s, v1.4s
	fmla    v7.4s, v3.4s, v1.4s
	fmla    v8.4s, v4.4s, v1.4s
	fmla    v9.4s, v5.4s, v1.4s
    st1     {v6.4s, v7.4s, v8.4s, v9.4s}, [x1], #64
	subs    w4, w4, #1
	b.ne    .Lmain_loop

.Lmedium_setup
    lsl    w6, w5, #2
    and    w5, w3, #3
    cbz    .Lshort_setup

.Lmedium_Loop
    ld1    {v2.4s}, [x0], #16
    ld1    {v6.4s}, [x1]
	st1    {v6.4s}, [x1], #16
	subs   w6, w6, #1
	b.ne   .Lmedium_loop

.Lsmall_setup
    cbz    w3, .Ldone

.Ldone
    ret
