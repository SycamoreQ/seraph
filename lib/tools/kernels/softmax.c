#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <math.h>


void softmax(float *x, int n) {
    float max = -INFINITY;
    float sum = 0.0;

    for (int i = 0; i < n; i++) {
        if (x[i] > max) max = x[i];
    }

    for (int j = 0; j < n; j++) {
        x[j] = expf(x[j] - max);
        sum += x[j];
    }

    for (int k = 0; k < n; k++) {
        x[k] = x[k] / sum;
    }
}


void softmax_restrict(const float * restrict src, float * restrict dst, int n) {
    float max = -INFINITY;
    float sum = 0.0;

    for (int i = 0; i < n; i++) {
        if (src[i] > max) max = src[i];
    }

    for (int j = 0; j < n; j++) {
        dst[j] = expf(src[j] - max);
        sum += dst[j];
    }

    for (int k = 0; k < n; k++) {
        dst[k] = dst[k] / sum;
    }
}
