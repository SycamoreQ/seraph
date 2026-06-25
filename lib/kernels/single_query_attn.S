// single_query_attn.S
//
// float single_query_attn(float *q , float *k float *v , int d)
//

#if defined(__APPLE__)
#define FN(name) _##name
#else
#define FN(name) name
#endif

	.text
	.global FN(single_query_attn_neon)
#if !defined(__APPLE__)
	.type FN(single_query_attn_neon), %function
#endif

FN(single_query_attn_neon):
    movi    v20.4s, #0
    movi    v21.4s, #0
    movi    v22.4s, #0
    movi    v23.4s, #0
    mov     w9, w3
    lsr     w4, w3, #4
    and     w5, w3, #15
    cbz     w4, .LQK_medium_dot_setup

.LQK_dot_loop:
    ld1     {v1.4s, v2.4s, v3.4s, v4.4s}, [x0], #64
    ld1     {v5.4s, v6.4s, v7.4s, v8.4s}, [x1], #64

    fmla    v20.4s, v1.4s, v5.4s
    fmla    v21.4s, v2.4s, v6.4s
    fmla    v22.4s, v3.4s, v7.4s
    fmla    v23.4s, v4.4s, v8.4s

    subs    w4, w4, #1
    b.ne    .LQK_dot_loop

.LQK_medium_dot_setup:
    lsr     w6, w5, #2
    and     w3, w5, #3
    cbz     w6, .LQK_tail_setup

.LQK_medium_dot_loop:
    ld1     {v10.4s}, [x0], #16
    ld1     {v11.4s}, [x1], #16
    fmla    v20.4s, v10.4s, v11.4s

    subs    w6, w6, #1
    b.ne    .LQK_medium_dot_loop

.LQK_tail_setup:
    cbz     w3, .LQK_combine

.LQK_tail_loop:
    ldr     s10, [x0], #4
    ldr     s11, [x1], #4
    fmul    s10, s10, s11
    fadd    s20, s20, s10

    subs    w3, w3, #1
    b.ne    .LQK_tail_loop

.LQK_combine:
    fadd    v20.4s, v20.4s, v21.4s
    fadd    v22.4s, v22.4s, v23.4s
    fadd    v20.4s, v20.4s, v22.4s

    b.ne    .LQK_store_scores

.LQK_store_scores:
    st1     {v20.4s}, [x9], #16
    st1     {v21.4s}, [x9], #16
    st1     {v22.4s}, [x9], #16
    st1     {v23.4s}, [x9], #16


.LV_setup:
    ucvtf   s3, w9
    fsqrt   s3, s3
    dup     v0.4s, s3
    fmul    v20.4s, v20.4s, v0.4s

    dup     v24.4s, v0.s[0]

    lsr     w4, w9, #2
    and     w5, w9, #3
    cbz     w4, .LV_tail_setup

.LV_loop:
    ld1     {v1.4s}, [x2], #16
    fmul    v2.4s, v1.4s, v20.4s
    st1     {v2.4s}, [x4], #16
    subs    w4, w4, #1
    b.ne    .LV_loop

.LV_tail_setup:
    cbz     w5, .Ldone

.LV_tail_loop:
    ldr     s1, [x2], #4
    fmul    s2, s1, s0
    str     s2, [x4], #4

    subs    w5, w5, #1
    b.ne    .LV_tail_loop

.Ldone:
    ret
