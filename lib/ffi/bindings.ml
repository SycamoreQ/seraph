open Bigarray

type f32arr = (float, float32_elt, c_layout) Array1.t

external saxpy_neon : float -> f32arr -> f32arr -> int -> unit
  = "caml_saxpy_neon"

external saxpy_gen : float -> f32arr -> f32arr -> int -> unit
  = "caml_saxpy_gen"

external saxpy_restrict_gen : float -> f32arr -> f32arr -> int -> unit
  = "caml_saxpy_restrict_gen"

external dot_neon : f32arr -> f32arr -> int -> float = "caml_dot_neon"

external dot_prod_gen : f32arr -> f32arr -> int -> float = "caml_dot_prod_gen"

external dot_prod_restrict_gen : f32arr -> f32arr -> int -> float
  = "caml_dot_prod_restrict_gen"
