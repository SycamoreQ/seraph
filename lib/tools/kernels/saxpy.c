#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>


void saxpy(float a , const float *x , float *y , int n) {
    for (int i = 0 ; i < n ; ++i) {
        y[i] = a *x[i] + y[i];
    }
}


void saxpy_restrict(float a, const float *restrict x, float *restrict y , int n) {
    for (int i = 0; i < n; ++i) {
        y[i] = a * x[i] + y[i];
    }
}
