/*

This is the optimized sum reduction kernel with some compile time optimizations. To
compare with sum_reduction.S.

sum_reduction.S already has loop unrolling implemented, so I will be going through the other
optimizations possible.

1. Hiding Load latencies
*/


#if defined(__APPLE__)
#define FN(name) _##name
#else
#define FN(name) name
#endif

    .text
    .global FN(sum_reduce_optim)
#if !defined(__APPLE__)
    .type FN(sum_reduce_optim), %function
#endif


FN(sum_reduce_optim):
    sub         sp, sp, #32
    stp         d8, d9, [sp]
    stp         d10, d11, [sp, #16]

    eor         v4.16b, v4.16b, v4.16b
    eor         v5.16b, v5.16b, v5.16b
    eor         v6.16b, v6.16b, v6.16b
    eor         v7.16b, v7.16b, v7.16b
    eor         v8.16b, v8.16b, v8.16b
    eor         v9.16b, v9.16b, v9.16b
    eor         v10.16b, v10.16b, v10.16b
    eor         v11.16b, v11.16b, v11.16b
    subs        x1, x1, #32
    blt         .L_check_single_vector
.L_unrolled_loop:
    ld1     {v0.4s, v1.4s, v2.4s, v3.4s}, [x0], #64
    ld1     {v12.4s, v13.4s, v14.4s, v15.4s}, [x0], #64
    fadd    v4.4s, v4.4s, v0.4s
    fadd    v5.4s, v5.4s, v1.4s
    fadd    v6.4s, v6.4s, v2.4s
    fadd    v7.4s, v7.4s, v3.4s
    fadd    v8.4s, v8.4s, v12.4s
    fadd    v9.4s, v9.4s, v13.4s
    fadd    v10.4s, v10.4s, v14.4s
    fadd    v11.4s, v11.4s, v15.4s
    subs    x1, x1, #32
    bge     .L_unrolled_loop

.L_check_single_vector:
    add         x1, x1, #32
    fadd        v4.4s, v4.4s, v5.4s
    fadd        v6.4s, v6.4s, v7.4s
    fadd        v8.4s, v8.4s, v9.4s
    fadd        v10.4s, v10.4s, v11.4s
    fadd        v4.4s,  v4.4s,  v6.4s
    fadd        v8.4s,  v8.4s,  v10.4s
    fadd        v4.4s,  v4.4s,  v8.4s
    subs        x1, x1, #4
    blt         .L_scalar_reduction

.L_single_vector_loop:
    ld1         {v0.4s}, [x0], #16
    fadd        v4.4s, v4.4s, v0.4s
    subs        x1, x1, #4
    bge         .L_single_vector_loop

.L_scalar_reduction:
    add         x1, x1, #4
    faddp       v4.4s, v4.4s, v4.4s
    faddp       s0, v4.2s
    cbz         x1, .L_done

.L_tail_loop:
    ldr         s1, [x0], #4
    fadd        s0, s0, s1
    subs        x1, x1, #1
    bgt         .L_tail_loop

.L_done:
    ldp         d8, d9, [sp]
    ldp         d10, d11, [sp, #16]
    add         sp, sp, #32
    ret
