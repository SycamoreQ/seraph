/* shim.c
 *
 * Thin C wrapper: unwraps OCaml Bigarray values into raw float* pointers
 * and calls into the hand-written NEON assembly with a plain C ABI.
 * Keeping this separate from the .S file means the assembly never has
 * to know anything about OCaml's runtime representation.
 */
#include <caml/mlvalues.h>
#include <caml/bigarray.h>
#include <caml/alloc.h>

extern void saxpy_neon(float a, const float *x, float *y, int n);

CAMLprim value caml_saxpy_neon(value a, value x, value y, value n)
{
  saxpy_neon((float)Double_val(a),
             (const float *)Caml_ba_data_val(x),
             (float *)Caml_ba_data_val(y),
             Int_val(n));
  return Val_unit;
}


extern float dot_neon(const float *x, const float *y, int n);

CAMLprim value caml_dot_neon(value x, value y, value n)
{
  float result = dot_neon((const float *)Caml_ba_data_val(x),
                           (const float *)Caml_ba_data_val(y),
                           Int_val(n));
  return caml_copy_double(result);
}
