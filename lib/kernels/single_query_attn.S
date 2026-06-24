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
    mov     x5, x0
    mov     w7,w1

    cbz     w4, .Ltail_loop

.Ldot_loop:
    ld1     {v1.4s, v2.4s, v3.4s, v4.4s}, [x0], #64 
    ld1     {v5.4s, v6.4s, v7.4s, v8.4s}, [x1], #64
    ld2     {v9.4s, v10.4s, v11.4s, v12.4s}, [x2], #64

    