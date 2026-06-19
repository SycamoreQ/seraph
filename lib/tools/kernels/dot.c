#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>


float dot_prod (const float *x , float *y , int n) {
    float sum = 0.0;
    for (int i = 0 ; i < n; ++i) {
        sum += x[i] * y[i];
    }

    return sum;
}

float dot_prod_restrict(const float *restrict x , float *restrict y , int n ) {
    float sum = 0.0;
    for (int i = 0; i < n ; ++i) {
        sum += x[i] * y[i];
    }

    return sum ;
}
