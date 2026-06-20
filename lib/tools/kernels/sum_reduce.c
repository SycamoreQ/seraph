#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>


float sum_reduce (const float *x , int n) {
    float sum = 0.0;
    for (int i = 0 ; i < n ; ++i) {
        sum += x[i];
    }
    return sum;
}


float sum_reduce_restrict (const float *restrict x , int n) {
    float sum = 0.0;
    for (int i = 0 ; i < n ; ++i) {
        sum += x[i];
    }
    return sum;
}
