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
    sub     sp, sp, #32
    stp     d8, d9, [sp]
    stp     d10, d11, [sp, #16]
    dup     v1.4s, v0.s[0]
    mov     w4, w3
    lsr     w5, w4, #4
    cbz     w5, .Lshort_setup

.Lmain_loop:
    ld1     {v2.4s}, [x0], #16
    ld1     {v3.4s}, [x0], #16
    ld1     {v4.4s}, [x0], #16
    ld1     {v5.4s}, [x0], #16
    ld1     {v6.4s}, [x1], #16
    ld1     {v7.4s}, [x1], #16
    ld1     {v8.4s}, [x1], #16
    ld1     {v9.4s}, [x1], #16
    fmla    v6.4s, v2.4s, v1.4s
    fmla    v7.4s, v3.4s, v1.4s
    fmla    v8.4s, v4.4s, v1.4s
    fmla    v9.4s, v5.4s, v1.4s
    sub     x1, x1, #64
    st1     {v6.4s}, [x1], #16
    st1     {v7.4s}, [x1], #16
    st1     {v8.4s}, [x1], #16
    st1     {v9.4s}, [x1], #16
    subs    w5, w5, #1
    b.ne    .Lmain_loop

.Lshort_setup:
    and     w5, w3, #15
    cbz     w5, .Ldone

.Lshort_loop:
    ldr     s2, [x0], #4
    ldr     s6, [x1]
    fmadd   s6, s2, s0, s6
    str     s6, [x1], #4
    subs    w5, w5, #1
    b.ne    .Lshort_loop

.Ldone:
    ldp     d8, d9, [sp]          // restore before returning
    ldp     d10, d11, [sp, #16]
    add     sp, sp, #32
    ret
