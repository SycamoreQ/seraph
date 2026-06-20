/*
 *
 * Thin C wrapper: unwraps OCaml Bigarray values into raw float* pointers
 * and calls into the hand-written NEON assembly with a plain C ABI.
 */
#include <caml/mlvalues.h>
#include <caml/bigarray.h>
#include <caml/alloc.h>


extern void saxpy_neon(float a, const float *x, float *y, int n);
extern void saxpy_optim(float a, const float *x, float *y, int n);       // Optimized Handwritten
extern void saxpy(float a, const float *x, float *y, int n);             // Clang Unrestricted
extern void saxpy_restrict(float a, const float *x, float *y, int n);    // Clang Restricted

CAMLprim value caml_saxpy_neon(value a, value x, value y, value n) {
  saxpy_neon((float)Double_val(a), (const float *)Caml_ba_data_val(x), (float *)Caml_ba_data_val(y), Int_val(n));
  return Val_unit;
}

CAMLprim value caml_saxpy_optim(value a, value x, value y, value n) {
  saxpy_optim((float)Double_val(a), (const float *)Caml_ba_data_val(x), (float *)Caml_ba_data_val(y), Int_val(n));
  return Val_unit;
}

CAMLprim value caml_saxpy_gen(value a, value x, value y, value n) {
  saxpy((float)Double_val(a), (const float *)Caml_ba_data_val(x), (float *)Caml_ba_data_val(y), Int_val(n));
  return Val_unit;
}

CAMLprim value caml_saxpy_restrict_gen(value a, value x, value y, value n) {
  saxpy_restrict((float)Double_val(a), (const float *)Caml_ba_data_val(x), (float *)Caml_ba_data_val(y), Int_val(n));
  return Val_unit;
}

extern float dot_neon(const float *x, const float *y, int n);
extern float dot_optim(const float *x, const float *y, int n);           // Optimized Handwritten
extern float dot_prod(const float *x, const float *y, int n);            // Clang Unrestricted
extern float dot_prod_restrict(const float *x, const float *y, int n);   // Clang Restricted

CAMLprim value caml_dot_neon(value x, value y, value n) {
  float result = dot_neon((const float *)Caml_ba_data_val(x), (const float *)Caml_ba_data_val(y), Int_val(n));
  return caml_copy_double(result);
}

CAMLprim value caml_dot_optim(value x, value y, value n) {
  float result = dot_optim((const float *)Caml_ba_data_val(x), (const float *)Caml_ba_data_val(y), Int_val(n));
  return caml_copy_double(result);
}

CAMLprim value caml_dot_prod_gen(value x, value y, value n) {
  float result = dot_prod((const float *)Caml_ba_data_val(x), (const float *)Caml_ba_data_val(y), Int_val(n));
  return caml_copy_double(result);
}

CAMLprim value caml_dot_prod_restrict_gen(value x, value y, value n) {
  float result = dot_prod_restrict((const float *)Caml_ba_data_val(x), (const float *)Caml_ba_data_val(y), Int_val(n));
  return caml_copy_double(result);
}

extern float sum_reduce_neon(const float *x, int n);
extern float sum_reduce_optim(const float *x, int n);                    // Optimized Handwritten
extern float sum_reduce(const float *x, int n);                          // Clang Unrestricted
extern float sum_reduce_restrict(const float *x, int n);                 // Clang Restricted

CAMLprim value caml_sum_reduce_neon(value x, value n) {
  float result = sum_reduce_neon((const float *)Caml_ba_data_val(x), Int_val(n));
  return caml_copy_double(result);
}

CAMLprim value caml_sum_reduce_optim(value x, value n) {
  float result = sum_reduce_optim((const float *)Caml_ba_data_val(x), Int_val(n));
  return caml_copy_double(result);
}

CAMLprim value caml_sum_reduce_gen(value x, value n) {
  float result = sum_reduce((const float *)Caml_ba_data_val(x), Int_val(n));
  return caml_copy_double(result);
}

CAMLprim value caml_sum_reduce_restrict_gen(value x, value n) {
  float result = sum_reduce_restrict((const float *)Caml_ba_data_val(x), Int_val(n));
  return caml_copy_double(result);
}
