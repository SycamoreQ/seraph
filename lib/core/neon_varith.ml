open Base
open Neon_types

module type ARITH = sig
  type elt
  type lanes
  type reg
  type t = (elt, lanes, reg) vec

  val vadd : t -> t -> t
  val vsub : t -> t -> t
  val vmul : t -> t -> t seraph_result
  val vfma : acc:t -> t -> t -> t seraph_result
  val vneg : t -> t seraph_result
  val vabs : t -> t seraph_result
  val vdup : int -> t
  val vpadd : t -> t -> t seraph_result
  val vredsum : t -> t
  val vredmax : t -> t
  val vredmin : t -> t
end

(* float32x4 — 4 lanes, q register *)
external vadd_float32_4_stub : float32_4 -> float32_4 -> float32_4 = "caml_seraph_vadd_float32_4"
external vsub_float32_4_stub : float32_4 -> float32_4 -> float32_4 = "caml_seraph_vsub_float32_4"
external vmul_float32_4_stub : float32_4 -> float32_4 -> float32_4 = "caml_seraph_vmul_float32_4"
external vfma_float32_4_stub : float32_4 -> float32_4 -> float32_4 -> float32_4 = "caml_seraph_vfma_float32_4"
external vneg_float32_4_stub : float32_4 -> float32_4 = "caml_seraph_vneg_float32_4"
external vabs_float32_4_stub : float32_4 -> float32_4 = "caml_seraph_vabs_float32_4"
external vdup_float32_4_stub : float -> float32_4 = "caml_seraph_vdup_float32_4"
external vpadd_float32_4_stub : float32_4 -> float32_4 -> float32_4 = "caml_seraph_vpadd_float32_4"
external vredsum_float32_4_stub : float32_4 -> float32_4 = "caml_seraph_vredsum_float32_4"
external vredmax_float32_4_stub : float32_4 -> float32_4 = "caml_seraph_vredmax_float32_4"
external vredmin_float32_4_stub : float32_4 -> float32_4 = "caml_seraph_vredmin_float32_4"

(* float32x2 — 2 lanes, d register *)
external vadd_float32_2_stub : float32_2 -> float32_2 -> float32_2 = "caml_seraph_vadd_float32_2"
external vsub_float32_2_stub : float32_2 -> float32_2 -> float32_2 = "caml_seraph_vsub_float32_2"
external vmul_float32_2_stub : float32_2 -> float32_2 -> float32_2 = "caml_seraph_vmul_float32_2"
external vfma_float32_2_stub : float32_2 -> float32_2 -> float32_2 -> float32_2 = "caml_seraph_vfma_float32_2"
external vneg_float32_2_stub : float32_2 -> float32_2 = "caml_seraph_vneg_float32_2"
external vabs_float32_2_stub : float32_2 -> float32_2 = "caml_seraph_vabs_float32_2"
external vdup_float32_2_stub : float -> float32_2 = "caml_seraph_vdup_float32_2"
external vpadd_float32_2_stub : float32_2 -> float32_2 -> float32_2 = "caml_seraph_vpadd_float32_2"
external vredsum_float32_2_stub : float32_2 -> float32_2 = "caml_seraph_vredsum_float32_2"
external vredmax_float32_2_stub : float32_2 -> float32_2 = "caml_seraph_vredmax_float32_2"
external vredmin_float32_2_stub : float32_2 -> float32_2 = "caml_seraph_vredmin_float32_2"

(** {4 Primitive layer — float64} *)
external vadd_float64_2_stub : float64_2 -> float64_2 -> float64_2 = "caml_seraph_vadd_float64_2"
external vsub_float64_2_stub : float64_2 -> float64_2 -> float64_2 = "caml_seraph_vsub_float64_2"
external vmul_float64_2_stub : float64_2 -> float64_2 -> float64_2 = "caml_seraph_vmul_float64_2"
external vfma_float64_2_stub : float64_2 -> float64_2 -> float64_2 -> float64_2 = "caml_seraph_vfma_float64_2"
external vneg_float64_2_stub : float64_2 -> float64_2 = "caml_seraph_vneg_float64_2"
external vabs_float64_2_stub : float64_2 -> float64_2 = "caml_seraph_vabs_float64_2"
external vdup_float64_2_stub : float -> float64_2 = "caml_seraph_vdup_float64_2"
external vredsum_float64_2_stub : float64_2 -> float64_2 = "caml_seraph_vredsum_float64_2"
external vredmax_float64_2_stub : float64_2 -> float64_2 = "caml_seraph_vredmax_float64_2"
external vredmin_float64_2_stub : float64_2 -> float64_2 = "caml_seraph_vredmin_float64_2"

(** {5 Primitive layer — int32} *)
external vadd_int32_4_stub : int32_4 -> int32_4 -> int32_4 = "caml_seraph_vadd_int32_4"
external vsub_int32_4_stub : int32_4 -> int32_4 -> int32_4 = "caml_seraph_vsub_int32_4"
external vmul_int32_4_stub : int32_4 -> int32_4 -> int32_4 = "caml_seraph_vmul_int32_4"
external vneg_int32_4_stub : int32_4 -> int32_4 = "caml_seraph_vneg_int32_4"
external vabs_int32_4_stub : int32_4 -> int32_4 = "caml_seraph_vabs_int32_4"
external vdup_int32_4_stub : int -> int32_4 = "caml_seraph_vdup_int32_4"
external vpadd_int32_4_stub : int32_4 -> int32_4 -> int32_4 = "caml_seraph_vpadd_int32_4"
external vredsum_int32_4_stub : int32_4 -> int32_4 = "caml_seraph_vredsum_int32_4"
external vredmax_int32_4_stub : int32_4 -> int32_4 = "caml_seraph_vredmax_int32_4"
external vredmin_int32_4_stub : int32_4 -> int32_4 = "caml_seraph_vredmin_int32_4"

external vadd_int32_2_stub : int32_2 -> int32_2 -> int32_2 = "caml_seraph_vadd_int32_2"
external vsub_int32_2_stub : int32_2 -> int32_2 -> int32_2 = "caml_seraph_vsub_int32_2"
external vmul_int32_2_stub : int32_2 -> int32_2 -> int32_2 = "caml_seraph_vmul_int32_2"
external vneg_int32_2_stub : int32_2 -> int32_2 = "caml_seraph_vneg_int32_2"
external vabs_int32_2_stub : int32_2 -> int32_2 = "caml_seraph_vabs_int32_2"
external vdup_int32_2_stub : int -> int32_2 = "caml_seraph_vdup_int32_2"
external vpadd_int32_2_stub : int32_2 -> int32_2 -> int32_2 = "caml_seraph_vpadd_int32_2"
external vredsum_int32_2_stub : int32_2 -> int32_2 = "caml_seraph_vredsum_int32_2"
external vredmax_int32_2_stub : int32_2 -> int32_2 = "caml_seraph_vredmax_int32_2"
external vredmin_int32_2_stub : int32_2 -> int32_2 = "caml_seraph_vredmin_int32_2"

(** {6 Primitive layer — int16} *)
external vadd_int16_8_stub : int16_8 -> int16_8 -> int16_8 = "caml_seraph_vadd_int16_8"
external vsub_int16_8_stub : int16_8 -> int16_8 -> int16_8 = "caml_seraph_vsub_int16_8"
external vmul_int16_8_stub : int16_8 -> int16_8 -> int16_8 = "caml_seraph_vmul_int16_8"
external vneg_int16_8_stub : int16_8 -> int16_8 = "caml_seraph_vneg_int16_8"
external vabs_int16_8_stub : int16_8 -> int16_8 = "caml_seraph_vabs_int16_8"
external vdup_int16_8_stub : int -> int16_8 = "caml_seraph_vdup_int16_8"
external vpadd_int16_8_stub : int16_8 -> int16_8 -> int16_8 = "caml_seraph_vpadd_int16_8"
external vredsum_int16_8_stub : int16_8 -> int16_8 = "caml_seraph_vredsum_int16_8"
external vredmax_int16_8_stub : int16_8 -> int16_8 = "caml_seraph_vredmax_int16_8"
external vredmin_int16_8_stub : int16_8 -> int16_8 = "caml_seraph_vredmin_int16_8"

external vadd_int16_4_stub : int16_4 -> int16_4 -> int16_4 = "caml_seraph_vadd_int16_4"
external vsub_int16_4_stub : int16_4 -> int16_4 -> int16_4 = "caml_seraph_vsub_int16_4"
external vmul_int16_4_stub : int16_4 -> int16_4 -> int16_4 = "caml_seraph_vmul_int16_4"
external vneg_int16_4_stub : int16_4 -> int16_4 = "caml_seraph_vneg_int16_4"
external vabs_int16_4_stub : int16_4 -> int16_4 = "caml_seraph_vabs_int16_4"
external vdup_int16_4_stub : int -> int16_4 = "caml_seraph_vdup_int16_4"
external vpadd_int16_4_stub : int16_4 -> int16_4 -> int16_4 = "caml_seraph_vpadd_int16_4"
external vredsum_int16_4_stub : int16_4 -> int16_4 = "caml_seraph_vredsum_int16_4"
external vredmax_int16_4_stub : int16_4 -> int16_4 = "caml_seraph_vredmax_int16_4"
external vredmin_int16_4_stub : int16_4 -> int16_4 = "caml_seraph_vredmin_int16_4"

(** {7 Primitive layer — int8} *)
external vadd_int8_16_stub : int8_16 -> int8_16 -> int8_16 = "caml_seraph_vadd_int8_16"
external vsub_int8_16_stub : int8_16 -> int8_16 -> int8_16 = "caml_seraph_vsub_int8_16"
external vneg_int8_16_stub : int8_16 -> int8_16 = "caml_seraph_vneg_int8_16"
external vabs_int8_16_stub : int8_16 -> int8_16 = "caml_seraph_vabs_int8_16"
external vdup_int8_16_stub : int -> int8_16 = "caml_seraph_vdup_int8_16"
external vpadd_int8_16_stub : int8_16 -> int8_16 -> int8_16 = "caml_seraph_vpadd_int8_16"
external vredsum_int8_16_stub : int8_16 -> int8_16 = "caml_seraph_vredsum_int8_16"
external vredmax_int8_16_stub : int8_16 -> int8_16 = "caml_seraph_vredmax_int8_16"
external vredmin_int8_16_stub : int8_16 -> int8_16 = "caml_seraph_vredmin_int8_16"

external vadd_int8_8_stub : int8_8 -> int8_8 -> int8_8 = "caml_seraph_vadd_int8_8"
external vsub_int8_8_stub : int8_8 -> int8_8 -> int8_8 = "caml_seraph_vsub_int8_8"
external vneg_int8_8_stub : int8_8 -> int8_8 = "caml_seraph_vneg_int8_8"
external vabs_int8_8_stub : int8_8 -> int8_8 = "caml_seraph_vabs_int8_8"
external vdup_int8_8_stub : int -> int8_8 = "caml_seraph_vdup_int8_8"
external vpadd_int8_8_stub : int8_8 -> int8_8 -> int8_8 = "caml_seraph_vpadd_int8_8"
external vredsum_int8_8_stub : int8_8 -> int8_8 = "caml_seraph_vredsum_int8_8"
external vredmax_int8_8_stub : int8_8 -> int8_8 = "caml_seraph_vredmax_int8_8"
external vredmin_int8_8_stub : int8_8 -> int8_8 = "caml_seraph_vredmin_int8_8"

(** {8 Primitive layer — uint8} *)
external vadd_uint8_16_stub : uint8_16 -> uint8_16 -> uint8_16 = "caml_seraph_vadd_uint8_16"
external vsub_uint8_16_stub : uint8_16 -> uint8_16 -> uint8_16 = "caml_seraph_vsub_uint8_16"
external vdup_uint8_16_stub : int -> uint8_16 = "caml_seraph_vdup_uint8_16"
external vpadd_uint8_16_stub : uint8_16 -> uint8_16 -> uint8_16 = "caml_seraph_vpadd_uint8_16"
external vredsum_uint8_16_stub : uint8_16 -> uint8_16 = "caml_seraph_vredsum_uint8_16"
external vredmax_uint8_16_stub : uint8_16 -> uint8_16 = "caml_seraph_vredmax_uint8_16"
external vredmin_uint8_16_stub : uint8_16 -> uint8_16 = "caml_seraph_vredmin_uint8_16"

external vadd_uint8_8_stub : uint8_8 -> uint8_8 -> uint8_8 = "caml_seraph_vadd_uint8_8"
external vsub_uint8_8_stub : uint8_8 -> uint8_8 -> uint8_8 = "caml_seraph_vsub_uint8_8"
external vdup_uint8_8_stub : int -> uint8_8 = "caml_seraph_vdup_uint8_8"
external vpadd_uint8_8_stub : uint8_8 -> uint8_8 -> uint8_8 = "caml_seraph_vpadd_uint8_8"
external vredsum_uint8_8_stub : uint8_8 -> uint8_8 = "caml_seraph_vredsum_uint8_8"
external vredmax_uint8_8_stub : uint8_8 -> uint8_8 = "caml_seraph_vredmax_uint8_8"
external vredmin_uint8_8_stub : uint8_8 -> uint8_8 = "caml_seraph_vredmin_uint8_8"

(* float32x4 *)
let vadd_float32_4 a b = vadd_float32_4_stub a b
let vsub_float32_4 a b = vsub_float32_4_stub a b
let vmul_float32_4 a b = vmul_float32_4_stub a b
let vfma_float32_4 ~acc a b = vfma_float32_4_stub acc a b
let vneg_float32_4 a = vneg_float32_4_stub a
let vabs_float32_4 a = vabs_float32_4_stub a
let vdup_float32_4 a = vdup_float32_4_stub a
let vpadd_float32_4 a b = vpadd_float32_4_stub a b
let vredsum_float32_4 a = vredsum_float32_4_stub a
let vredmax_float32_4 a = vredmax_float32_4_stub a
let vredmin_float32_4 a = vredmin_float32_4_stub a

(* float32x2 *)
let vadd_float32_2 a b = vadd_float32_2_stub a b
let vsub_float32_2 a b = vsub_float32_2_stub a b
let vmul_float32_2 a b = vmul_float32_2_stub a b
let vfma_float32_2 ~acc a b = vfma_float32_2_stub acc a b
let vneg_float32_2 a = vneg_float32_2_stub a
let vabs_float32_2 a = vabs_float32_2_stub a
let vdup_float32_2 a = vdup_float32_2_stub a
let vpadd_float32_2 a b = vpadd_float32_2_stub a b
let vredsum_float32_2 a = vredsum_float32_2_stub a
let vredmax_float32_2 a = vredmax_float32_2_stub a
let vredmin_float32_2 a = vredmin_float32_2_stub a

(* float64x2 *)
let vadd_float64_2 a b = vadd_float64_2_stub a b
let vsub_float64_2 a b = vsub_float64_2_stub a b
let vmul_float64_2 a b = vmul_float64_2_stub a b
let vfma_float64_2 ~acc a b = vfma_float64_2_stub acc a b
let vneg_float64_2 a = vneg_float64_2_stub a
let vabs_float64_2 a = vabs_float64_2_stub a
let vdup_float64_2 a = vdup_float64_2_stub a
let vredsum_float64_2 a = vredsum_float64_2_stub a
let vredmax_float64_2 a = vredmax_float64_2_stub a
let vredmin_float64_2 a = vredmin_float64_2_stub a

(* int32x4 *)
let vadd_int32_4 a b = vadd_int32_4_stub a b
let vsub_int32_4 a b = vsub_int32_4_stub a b
let vmul_int32_4 a b = vmul_int32_4_stub a b
let vneg_int32_4 a = vneg_int32_4_stub a
let vabs_int32_4 a = vabs_int32_4_stub a
let vdup_int32_4 a = vdup_int32_4_stub a
let vpadd_int32_4 a b = vpadd_int32_4_stub a b
let vredsum_int32_4 a = vredsum_int32_4_stub a
let vredmax_int32_4 a = vredmax_int32_4_stub a
let vredmin_int32_4 a = vredmin_int32_4_stub a

(* int32x2 *)
let vadd_int32_2 a b = vadd_int32_2_stub a b
let vsub_int32_2 a b = vsub_int32_2_stub a b
let vmul_int32_2 a b = vmul_int32_2_stub a b
let vneg_int32_2 a = vneg_int32_2_stub a
let vabs_int32_2 a = vabs_int32_2_stub a
let vdup_int32_2 a = vdup_int32_2_stub a
let vpadd_int32_2 a b = vpadd_int32_2_stub a b
let vredsum_int32_2 a = vredsum_int32_2_stub a
let vredmax_int32_2 a = vredmax_int32_2_stub a
let vredmin_int32_2 a = vredmin_int32_2_stub a

(* int16x8 *)
let vadd_int16_8 a b = vadd_int16_8_stub a b
let vsub_int16_8 a b = vsub_int16_8_stub a b
let vmul_int16_8 a b = vmul_int16_8_stub a b
let vneg_int16_8 a = vneg_int16_8_stub a
let vabs_int16_8 a = vabs_int16_8_stub a
let vdup_int16_8 a = vdup_int16_8_stub a
let vpadd_int16_8 a b = vpadd_int16_8_stub a b
let vredsum_int16_8 a = vredsum_int16_8_stub a
let vredmax_int16_8 a = vredmax_int16_8_stub a
let vredmin_int16_8 a = vredmin_int16_8_stub a

(* int16x4 *)
let vadd_int16_4 a b = vadd_int16_4_stub a b
let vsub_int16_4 a b = vsub_int16_4_stub a b
let vmul_int16_4 a b = vmul_int16_4_stub a b
let vneg_int16_4 a = vneg_int16_4_stub a
let vabs_int16_4 a = vabs_int16_4_stub a
let vdup_int16_4 a = vdup_int16_4_stub a
let vpadd_int16_4 a b = vpadd_int16_4_stub a b
let vredsum_int16_4 a = vredsum_int16_4_stub a
let vredmax_int16_4 a = vredmax_int16_4_stub a
let vredmin_int16_4 a = vredmin_int16_4_stub a

(* int8x16 *)
let vadd_int8_16 a b = vadd_int8_16_stub a b
let vsub_int8_16 a b = vsub_int8_16_stub a b
let vneg_int8_16 a = vneg_int8_16_stub a
let vabs_int8_16 a = vabs_int8_16_stub a
let vdup_int8_16 a = vdup_int8_16_stub a
let vpadd_int8_16 a b = vpadd_int8_16_stub a b
let vredsum_int8_16 a = vredsum_int8_16_stub a
let vredmax_int8_16 a = vredmax_int8_16_stub a
let vredmin_int8_16 a = vredmin_int8_16_stub a

(* int8x8 *)
let vadd_int8_8 a b = vadd_int8_8_stub a b
let vsub_int8_8 a b = vsub_int8_8_stub a b
let vneg_int8_8 a = vneg_int8_8_stub a
let vabs_int8_8 a = vabs_int8_8_stub a
let vdup_int8_8 a = vdup_int8_8_stub a
let vpadd_int8_8 a b = vpadd_int8_8_stub a b
let vredsum_int8_8 a = vredsum_int8_8_stub a
let vredmax_int8_8 a = vredmax_int8_8_stub a
let vredmin_int8_8 a = vredmin_int8_8_stub a

(* uint8x16 *)
let vadd_uint8_16 a b = vadd_uint8_16_stub a b
let vsub_uint8_16 a b = vsub_uint8_16_stub a b
let vdup_uint8_16 a = vdup_uint8_16_stub a
let vpadd_uint8_16 a b = vpadd_uint8_16_stub a b
let vredsum_uint8_16 a = vredsum_uint8_16_stub a
let vredmax_uint8_16 a = vredmax_uint8_16_stub a
let vredmin_uint8_16 a = vredmin_uint8_16_stub a

(* uint8x8 *)
let vadd_uint8_8 a b = vadd_uint8_8_stub a b
let vsub_uint8_8 a b = vsub_uint8_8_stub a b
let vdup_uint8_8 a = vdup_uint8_8_stub a
let vpadd_uint8_8 a b = vpadd_uint8_8_stub a b
let vredsum_uint8_8 a = vredsum_uint8_8_stub a
let vredmax_uint8_8 a = vredmax_uint8_8_stub a
let vredmin_uint8_8 a = vredmin_uint8_8_stub a


module Float32x4 = struct
  type elt = seraph_float32
  type lanes = seraph_n4
  type reg = q
  type t = float32_4

  let vadd = vadd_float32_4
  let vsub = vsub_float32_4
  let vmul a b = Ok (vmul_float32_4 a b)
  let vfma ~acc a b = Ok (vfma_float32_4 ~acc a b)
  let vneg a = Ok (vneg_float32_4 a)
  let vabs a = Ok (vabs_float32_4 a)
  let vdup n = vdup_float32_4 (Float.of_int n)
  let vpadd a b = Ok (vpadd_float32_4 a b)
  let vredsum = vredsum_float32_4
  let vredmax = vredmax_float32_4
  let vredmin = vredmin_float32_4
end

module Float32x2 = struct
  type elt = seraph_float32
  type lanes = seraph_n2
  type reg = d
  type t = float32_2

  let vadd = vadd_float32_2
  let vsub = vsub_float32_2
  let vmul a b = Ok (vmul_float32_2 a b)
  let vfma ~acc a b = Ok (vfma_float32_2 ~acc a b)
  let vneg a = Ok (vneg_float32_2 a)
  let vabs a = Ok (vabs_float32_2 a)
  let vdup n = vdup_float32_2 (Float.of_int n)
  let vpadd a b = Ok (vpadd_float32_2 a b)
  let vredsum = vredsum_float32_2
  let vredmax = vredmax_float32_2
  let vredmin = vredmin_float32_2
end

module Float64x2 = struct
  type elt = seraph_float64
  type lanes = seraph_n2
  type reg = q
  type t = float64_2

  let vadd = vadd_float64_2
  let vsub = vsub_float64_2
  let vmul a b = Ok (vmul_float64_2 a b)
  let vfma ~acc a b = Ok (vfma_float64_2 ~acc a b)
  let vneg a = Ok (vneg_float64_2 a)
  let vabs a = Ok (vabs_float64_2 a)
  let vdup n = vdup_float64_2 (Float.of_int n)
  let vpadd _ _ = Error Unsupported_op
  let vredsum = vredsum_float64_2
  let vredmax = vredmax_float64_2
  let vredmin = vredmin_float64_2
end

module Int32x4 = struct
  type elt = seraph_int32
  type lanes = seraph_n4
  type reg = q
  type t = int32_4

  let vadd = vadd_int32_4
  let vsub = vsub_int32_4
  let vmul a b = Ok (vmul_int32_4 a b)
  let vfma ~acc:_ _ _ = Error Unsupported_op
  let vneg a = Ok (vneg_int32_4 a)
  let vabs a = Ok (vabs_int32_4 a)
  let vdup n = vdup_int32_4 n
  let vpadd a b = Ok (vpadd_int32_4 a b)
  let vredsum = vredsum_int32_4
  let vredmax = vredmax_int32_4
  let vredmin = vredmin_int32_4
end

module Int32x2 = struct
  type elt = seraph_int32
  type lanes = seraph_n2
  type reg = d
  type t = int32_2

  let vadd = vadd_int32_2
  let vsub = vsub_int32_2
  let vmul a b = Ok (vmul_int32_2 a b)
  let vfma ~acc:_ _ _ = Error Unsupported_op
  let vneg a = Ok (vneg_int32_2 a)
  let vabs a = Ok (vabs_int32_2 a)
  let vdup n = vdup_int32_2 n
  let vpadd a b = Ok (vpadd_int32_2 a b)
  let vredsum = vredsum_int32_2
  let vredmax = vredmax_int32_2
  let vredmin = vredmin_int32_2
end

module Int16x8 = struct
  type elt = seraph_int16
  type lanes = seraph_n8
  type reg = q
  type t = int16_8

  let vadd = vadd_int16_8
  let vsub = vsub_int16_8
  let vmul a b = Ok (vmul_int16_8 a b)
  let vfma ~acc:_ _ _ = Error Unsupported_op
  let vneg a = Ok (vneg_int16_8 a)
  let vabs a = Ok (vabs_int16_8 a)
  let vdup n = vdup_int16_8 n
  let vpadd a b = Ok (vpadd_int16_8 a b)
  let vredsum = vredsum_int16_8
  let vredmax = vredmax_int16_8
  let vredmin = vredmin_int16_8
end

module Int16x4 = struct
  type elt = seraph_int16
  type lanes = seraph_n4
  type reg = d
  type t = int16_4

  let vadd = vadd_int16_4
  let vsub = vsub_int16_4
  let vmul a b = Ok (vmul_int16_4 a b)
  let vfma ~acc:_ _ _ = Error Unsupported_op
  let vneg a = Ok (vneg_int16_4 a)
  let vabs a = Ok (vabs_int16_4 a)
  let vdup n = vdup_int16_4 n
  let vpadd a b = Ok (vpadd_int16_4 a b)
  let vredsum = vredsum_int16_4
  let vredmax = vredmax_int16_4
  let vredmin = vredmin_int16_4
end

module Int8x16 = struct
  type elt = seraph_int8
  type lanes = seraph_n16
  type reg = q
  type t = int8_16

  let vadd = vadd_int8_16
  let vsub = vsub_int8_16
  let vmul _ _ = Error Unsupported_op
  let vfma ~acc:_ _ _ = Error Unsupported_op
  let vneg a = Ok (vneg_int8_16 a)
  let vabs a = Ok (vabs_int8_16 a)
  let vdup n = vdup_int8_16 n
  let vpadd a b = Ok (vpadd_int8_16 a b)
  let vredsum = vredsum_int8_16
  let vredmax = vredmax_int8_16
  let vredmin = vredmin_int8_16
end

module Int8x8 = struct
  type elt = seraph_int8
  type lanes = seraph_n8
  type reg = d
  type t = int8_8

  let vadd = vadd_int8_8
  let vsub = vsub_int8_8
  let vmul _ _ = Error Unsupported_op
  let vfma ~acc:_ _ _ = Error Unsupported_op
  let vneg a = Ok (vneg_int8_8 a)
  let vabs a = Ok (vabs_int8_8 a)
  let vdup n = vdup_int8_8 n
  let vpadd a b = Ok (vpadd_int8_8 a b)
  let vredsum = vredsum_int8_8
  let vredmax = vredmax_int8_8
  let vredmin = vredmin_int8_8
end

module Uint8x16 = struct
  type elt = seraph_uint8
  type lanes = seraph_n16
  type reg = q
  type t = uint8_16

  let vadd = vadd_uint8_16
  let vsub = vsub_uint8_16
  let vmul _ _ = Error Unsupported_op
  let vfma ~acc:_ _ _ = Error Unsupported_op
  let vneg _ = Error Unsupported_op
  let vabs _ = Error Unsupported_op
  let vdup n = vdup_uint8_16 n
  let vpadd a b = Ok (vpadd_uint8_16 a b)
  let vredsum = vredsum_uint8_16
  let vredmax = vredmax_uint8_16
  let vredmin = vredmin_uint8_16
end

module Uint8x8 = struct
  type elt = seraph_uint8
  type lanes = seraph_n8
  type reg = d
  type t = uint8_8

  let vadd = vadd_uint8_8
  let vsub = vsub_uint8_8
  let vmul _ _ = Error Unsupported_op
  let vfma ~acc:_ _ _ = Error Unsupported_op
  let vneg _ = Error Unsupported_op
  let vabs _ = Error Unsupported_op
  let vdup n = vdup_uint8_8 n
  let vpadd a b = Ok (vpadd_uint8_8 a b)
  let vredsum = vredsum_uint8_8
  let vredmax = vredmax_uint8_8
  let vredmin = vredmin_uint8_8
end
