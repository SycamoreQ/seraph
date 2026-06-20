// sum_reduce_neon.S
// float sum_reduce_neon(const float *arr , int n)
//
// AAPCS64 argument registers for this signature:
// x0 = x
// w2 = n
//


#if defined(__APPLE__)
#define FN(name) _##name
#else
#define FN(name) name
#endif

    .text
    .global FN(sum_reduce_neon)
#if !defined(__APPLE__)
    .type FN(sum_reduce_neon), %function
#endif

FN(sum_reduce_neon):
    // 1. Initialize vector accumulators to 0.0 (All bits 0 = 0.0f in IEEE 754)
    eor         v4.16b, v4.16b, v4.16b  // acc 1
    eor         v5.16b, v5.16b, v5.16b  // acc 2
    eor         v6.16b, v6.16b, v6.16b  // acc 3
    eor         v7.16b, v7.16b, v7.16b  // acc 4

    // Check if we have at least 16 elements (16 * 4 bytes = 64 bytes)
    subs        x1, x1, #16
    blt         .l_check_single_vector

.l_unrolled_loop:
    // Load 16 floating-point elements
    ld1         {v0.4s, v1.4s, v2.4s, v3.4s}, [x0], #64

    // Parallel Floating-Point Accumulation
    fadd        v4.4s, v4.4s, v0.4s
    fadd        v5.4s, v5.4s, v1.4s
    fadd        v6.4s, v6.4s, v2.4s
    fadd        v7.4s, v7.4s, v3.4s

    subs        x1, x1, #16
    bge         .l_unrolled_loop

.l_check_single_vector:
    add         x1, x1, #16

    // Collapse our 4 independent float accumulators into v4
    fadd        v4.4s, v4.4s, v5.4s
    fadd        v6.4s, v6.4s, v7.4s
    fadd        v4.4s, v4.4s, v6.4s

    // Check if we can process remaining single vectors (4 elements = 16 bytes)
    subs        x1, x1, #4
    blt         .l_scalar_reduction

.l_single_vector_loop:
    ld1         {v0.4s}, [x0], #16
    fadd        v4.4s, v4.4s, v0.4s
    subs        x1, x1, #4
    bge         .l_single_vector_loop

.l_scalar_reduction:
    add         x1, x1, #4

    // Pairwise reduction to collapse v4.4s [A, B, C, D] into scalar s0
    // faddp v4.4s, v4.4s, v4.4s yields [A+B, C+D, A+B, C+D]
    faddp       v4.4s, v4.4s, v4.4s
    // faddp s0, v4.2s takes the lower two lanes [A+B, C+D] and adds them -> s0 = A+B+C+D
    faddp       s0, v4.2s

    // x0 is safely left untouched as the memory pointer!
    cbz         x1, .l_done

.l_tail_loop:
    ldr         s1, [x0], #4            // Load single 32-bit float into s1, advance pointer
    fadd        s0, s0, s1              // Scalar float accumulate directly into return register s0
    subs        x1, x1, #1
    bgt         .l_tail_loop

.l_done:
    ret
