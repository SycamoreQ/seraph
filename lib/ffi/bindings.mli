open Bigarray

type f32arr = (float, float32_elt, c_layout) Array1.t

val saxpy_neon : float -> f32arr -> f32arr -> int -> unit
val saxpy_optim : float -> f32arr -> f32arr -> int -> unit
val saxpy_gen : float -> f32arr -> f32arr -> int -> unit
val saxpy_restrict_gen : float -> f32arr -> f32arr -> int -> unit

val dot_neon : f32arr -> f32arr -> int -> float
val dot_optim : f32arr -> f32arr -> int -> float
val dot_prod_gen : f32arr -> f32arr -> int -> float
val dot_prod_restrict_gen : f32arr -> f32arr -> int -> float

(** Sum Reduction Kernels **)
val sum_reduce_neon : f32arr -> int -> float
val sum_reduce_optim : f32arr -> int -> float
val sum_reduce_gen : f32arr -> int -> float
val sum_reduce_restrict_gen : f32arr -> int -> float
