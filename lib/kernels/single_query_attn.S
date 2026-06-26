// single_query_attn
//
// void single_query_attn(const float *Q, const float *K, const float *V,
// float *scores, float *out, int N, int D)
//
// AAPCS notation
// Q = x0
// K = x1
// V = x2
// scores = x3
// out = x4
// N = w5
// D = w6


#if defined(__APPLE__)
#define FN(name) _##name
#else
#define FN(name) name
#endif

	.text
	.global FN(single_query_attn)
#if !defined(__APPLE__)
	.type FN(single_query_attn), %function
#endif

FN(single_query_attn):
    movi    v20.4s, #0
    movi    v21.4s, #0
    movi    v22.4s, #0
    movi    v23.4s, #0
    mov     w9,     w5
    mov     w10,    w6
    lsr     w4, w9, #4
    and     w5, w9, #15
    cbz     w4, .LQK_medium_dot_setup

.LQK_dot_loop:
    ld1     {v1.4s, v2.4s, v3.4s, v4.4s}, [x0], #64         //load Q
    ld1     {v5.4s, v6.4s, v7.4s, v8.4s}, [x1], #64         //load K
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

.LQK_combine:
    fadd    v20.4s, v20.4s, v21.4s
    fadd    v22.4s, v22.4s, v23.4s
    fadd    v20.4s, v20.4s, v22.4s
    faddp   v20.4s, v20.4s, v20.4s
    faddp   s20, v20.2s
    fmul    s20, s20, s1

.LV_setup:
    ucvtf   s0, w10
    fsqrt   s0, s0            // sqrt(D)
    frecpe  s1, s0            // initial estimate of 1/sqrt(D)
    frecps  s2, s0, s1        // refinement factor
    fmul    s1, s1, s2        // s1 = 1/sqrt(D)
    movi    x3, #0
    cbz     .LV_medium_loop

.LV_loop:
    ld1    {v20.4s, v21.4s, v22.4s, v23.4s}, [x2], #64
    dup    v24.4s, s0, #64
    ld1    {v25.4s, v26.4s, v27.4s, v28.4s}, [x3], #64
    fmla
