open Bigarray

type f32arr = (float, float32_elt, c_layout) Array1.t

external saxpy_neon : float -> f32arr -> f32arr -> int -> unit
  = "caml_saxpy_neon"

external dot_neon : f32arr -> f32arr -> int -> float = "caml_dot_neon"

(**external sum_neon : f32arr -> int -> float = "caml_sum_neon"**)

(**external fir_neon : f32arr -> f32arr -> f32arr -> int -> int -> unit
= "caml_fir_neon" **)
