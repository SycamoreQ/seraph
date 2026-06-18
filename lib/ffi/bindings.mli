open Bigarray

type f32arr = (float, float32_elt, c_layout) Array1.t

val saxpy_neon : float -> f32arr -> f32arr -> int -> unit

val dot_neon : f32arr -> f32arr -> int -> float

(**val sum_neon : f32arr -> int -> float

val fir_neon : f32arr -> f32arr -> f32arr -> int -> int -> unit **)
