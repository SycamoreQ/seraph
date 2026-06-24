open Bigarray

type f32arr = (float, float32_elt, c_layout) Array1.t

external saxpy_neon : float -> f32arr -> f32arr -> int -> unit = "caml_saxpy_neon"
external saxpy_optim : float -> f32arr -> f32arr -> int -> unit = "caml_saxpy_optim"
external saxpy_gen : float -> f32arr -> f32arr -> int -> unit = "caml_saxpy_gen"
external saxpy_restrict_gen : float -> f32arr -> f32arr -> int -> unit = "caml_saxpy_restrict_gen"

external dot_neon : f32arr -> f32arr -> int -> float = "caml_dot_neon"
external dot_optim : f32arr -> f32arr -> int -> float = "caml_dot_optim"
external dot_prod_gen : f32arr -> f32arr -> int -> float = "caml_dot_prod_gen"
external dot_prod_restrict_gen : f32arr -> f32arr -> int -> float = "caml_dot_prod_restrict_gen"

external sum_reduce_neon : f32arr -> int -> float = "caml_sum_reduce_neon"
external sum_reduce_optim : f32arr -> int -> float = "caml_sum_reduce_optim"
external sum_reduce_gen : f32arr -> int -> float = "caml_sum_reduce_gen"
external sum_reduce_restrict_gen : f32arr -> int -> float = "caml_sum_reduce_restrict_gen"

external softmax_neon : f32arr -> int -> unit = "caml_softmax_neon"
external softmax_gen : f32arr -> int -> unit = "caml_softmax_gen"
external softmax_restrict_gen : f32arr -> int -> unit = "caml_softmax_restrict_gen"
