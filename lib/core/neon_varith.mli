(** Seraph — ARM NEON intrinsics for OXCaml

    Neon_varith: Arithmetic operations on NEON vectors.

    Structure:
      - Primitive layer: one function per concrete type, maps 1:1
        to arm_neon.h intrinsic names. Zero dispatch overhead.
      - Functor layer: [ARITH] module type + one module per concrete
        vector type. Open one to get clean unqualified call sites.

    Naming convention for primitives:
      v<op>_<elt><lanes>
      e.g. vadd_float32_4, vmul_int16_8, vfma_float32_4 *)

open Neon_types

(** {1 ARITH module type — functor layer}

    Each concrete vector type gets a module satisfying [ARITH].
    Open one at the use site for clean syntax:

    {[
      open Seraph.Neon_varith.Float32x4
      let c = vadd a b
      let d = vfma ~acc:c a b
    ]} *)

module type ARITH = sig
  type elt
  type lanes
  type reg

  (** The concrete vector type this module operates on. *)
  type t = (elt, lanes, reg) vec

  (** Element-wise addition. *)
  val vadd : t -> t -> t

  (** Element-wise subtraction. *)
  val vsub : t -> t -> t

  (** Element-wise multiplication. *)
  val vmul : t -> t -> t seraph_result

  (** Fused multiply-accumulate: [vfma ~acc a b = acc + a * b].
      Single rounding, no intermediate precision loss.
      Only available for float types — integer types raise [Unsupported_op]. *)
  val vfma : acc:t -> t -> t -> t seraph_result

  (** Element-wise negation. *)
  val vneg : t -> t seraph_result

  (** Element-wise absolute value. *)
  val vabs : t -> t seraph_result

  (** Broadcast a scalar to all lanes. *)
  val vdup : int -> t

  (** Pairwise addition: adjacent lanes are summed, result is half-width.
      e.g. [float32x4 -> float32x2]. *)
  val vpadd : t -> t -> t seraph_result

  (** Horizontal reduction: sum all lanes, result is a scalar in lane 0. *)
  val vredsum : t -> t

  (** Horizontal reduction: max of all lanes, result in lane 0. *)
  val vredmax : t -> t

  (** Horizontal reduction: min of all lanes, result in lane 0. *)
  val vredmin : t -> t
end

(** {2 Primitive layer — float32} *)

(** {3 float32x4 — 4 lanes, q register} *)

val vadd_float32_4 : float32_4 -> float32_4 -> float32_4
val vsub_float32_4 : float32_4 -> float32_4 -> float32_4
val vmul_float32_4 : float32_4 -> float32_4 -> float32_4

(** [vfma_float32_4 ~acc a b] computes [acc + a * b] with single rounding. *)
val vfma_float32_4 : acc:float32_4 -> float32_4 -> float32_4 -> float32_4

val vneg_float32_4 : float32_4 -> float32_4
val vabs_float32_4 : float32_4 -> float32_4
val vdup_float32_4 : float -> float32_4
val vpadd_float32_4 : float32_4 -> float32_4 -> float32_4

(** Sum all 4 lanes. Result is a float32x4 with the sum in lane 0. *)
val vredsum_float32_4 : float32_4 -> float32_4

(** Max across all 4 lanes. Result in lane 0. *)
val vredmax_float32_4 : float32_4 -> float32_4

(** Min across all 4 lanes. Result in lane 0. *)
val vredmin_float32_4 : float32_4 -> float32_4

(** {3 float32x2 — 2 lanes, d register} *)

val vadd_float32_2 : float32_2 -> float32_2 -> float32_2
val vsub_float32_2 : float32_2 -> float32_2 -> float32_2
val vmul_float32_2 : float32_2 -> float32_2 -> float32_2
val vfma_float32_2 : acc:float32_2 -> float32_2 -> float32_2 -> float32_2
val vneg_float32_2 : float32_2 -> float32_2
val vabs_float32_2 : float32_2 -> float32_2
val vdup_float32_2 : float -> float32_2
val vpadd_float32_2 : float32_2 -> float32_2 -> float32_2
val vredsum_float32_2 : float32_2 -> float32_2
val vredmax_float32_2 : float32_2 -> float32_2
val vredmin_float32_2 : float32_2 -> float32_2

(** {4 Primitive layer — float64} *)

val vadd_float64_2 : float64_2 -> float64_2 -> float64_2
val vsub_float64_2 : float64_2 -> float64_2 -> float64_2
val vmul_float64_2 : float64_2 -> float64_2 -> float64_2
val vfma_float64_2 : acc:float64_2 -> float64_2 -> float64_2 -> float64_2
val vneg_float64_2 : float64_2 -> float64_2
val vabs_float64_2 : float64_2 -> float64_2
val vdup_float64_2 : float -> float64_2
val vredsum_float64_2 : float64_2 -> float64_2
val vredmax_float64_2 : float64_2 -> float64_2
val vredmin_float64_2 : float64_2 -> float64_2


(** {5 Primitive layer — int32} *)

val vadd_int32_4 : int32_4 -> int32_4 -> int32_4
val vsub_int32_4 : int32_4 -> int32_4 -> int32_4
val vmul_int32_4 : int32_4 -> int32_4 -> int32_4
val vneg_int32_4 : int32_4 -> int32_4
val vabs_int32_4 : int32_4 -> int32_4
val vdup_int32_4 : int -> int32_4
val vpadd_int32_4 : int32_4 -> int32_4 -> int32_4
val vredsum_int32_4 : int32_4 -> int32_4
val vredmax_int32_4 : int32_4 -> int32_4
val vredmin_int32_4 : int32_4 -> int32_4

val vadd_int32_2 : int32_2 -> int32_2 -> int32_2
val vsub_int32_2 : int32_2 -> int32_2 -> int32_2
val vmul_int32_2 : int32_2 -> int32_2 -> int32_2
val vneg_int32_2 : int32_2 -> int32_2
val vabs_int32_2 : int32_2 -> int32_2
val vdup_int32_2 : int -> int32_2
val vpadd_int32_2 : int32_2 -> int32_2 -> int32_2
val vredsum_int32_2 : int32_2 -> int32_2
val vredmax_int32_2 : int32_2 -> int32_2
val vredmin_int32_2 : int32_2 -> int32_2


(** {6 Primitive layer — int16} *)

val vadd_int16_8 : int16_8 -> int16_8 -> int16_8
val vsub_int16_8 : int16_8 -> int16_8 -> int16_8
val vmul_int16_8 : int16_8 -> int16_8 -> int16_8
val vneg_int16_8 : int16_8 -> int16_8
val vabs_int16_8 : int16_8 -> int16_8
val vdup_int16_8 : int -> int16_8
val vpadd_int16_8 : int16_8 -> int16_8 -> int16_8
val vredsum_int16_8 : int16_8 -> int16_8
val vredmax_int16_8 : int16_8 -> int16_8
val vredmin_int16_8 : int16_8 -> int16_8

val vadd_int16_4 : int16_4 -> int16_4 -> int16_4
val vsub_int16_4 : int16_4 -> int16_4 -> int16_4
val vmul_int16_4 : int16_4 -> int16_4 -> int16_4
val vneg_int16_4 : int16_4 -> int16_4
val vabs_int16_4 : int16_4 -> int16_4
val vdup_int16_4 : int -> int16_4
val vpadd_int16_4 : int16_4 -> int16_4 -> int16_4
val vredsum_int16_4 : int16_4 -> int16_4
val vredmax_int16_4 : int16_4 -> int16_4
val vredmin_int16_4 : int16_4 -> int16_4


(* ------------------------------------------------------------------ *)
(** {7 Primitive layer — int8} *)
(* ------------------------------------------------------------------ *)

val vadd_int8_16 : int8_16 -> int8_16 -> int8_16
val vsub_int8_16 : int8_16 -> int8_16 -> int8_16
val vneg_int8_16 : int8_16 -> int8_16
val vabs_int8_16 : int8_16 -> int8_16
val vdup_int8_16 : int -> int8_16
val vpadd_int8_16 : int8_16 -> int8_16 -> int8_16
val vredsum_int8_16 : int8_16 -> int8_16
val vredmax_int8_16 : int8_16 -> int8_16
val vredmin_int8_16 : int8_16 -> int8_16

val vadd_int8_8 : int8_8 -> int8_8 -> int8_8
val vsub_int8_8 : int8_8 -> int8_8 -> int8_8
val vneg_int8_8 : int8_8 -> int8_8
val vabs_int8_8 : int8_8 -> int8_8
val vdup_int8_8 : int -> int8_8
val vpadd_int8_8 : int8_8 -> int8_8 -> int8_8
val vredsum_int8_8 : int8_8 -> int8_8
val vredmax_int8_8 : int8_8 -> int8_8
val vredmin_int8_8 : int8_8 -> int8_8

(** {8 Primitive layer — uint8 (quantization workhorse)} *)

val vadd_uint8_16 : uint8_16 -> uint8_16 -> uint8_16
val vsub_uint8_16 : uint8_16 -> uint8_16 -> uint8_16
val vdup_uint8_16 : int -> uint8_16
val vpadd_uint8_16 : uint8_16 -> uint8_16 -> uint8_16
val vredsum_uint8_16 : uint8_16 -> uint8_16
val vredmax_uint8_16 : uint8_16 -> uint8_16
val vredmin_uint8_16 : uint8_16 -> uint8_16

val vadd_uint8_8 : uint8_8 -> uint8_8 -> uint8_8
val vsub_uint8_8 : uint8_8 -> uint8_8 -> uint8_8
val vdup_uint8_8 : int -> uint8_8
val vpadd_uint8_8 : uint8_8 -> uint8_8 -> uint8_8
val vredsum_uint8_8 : uint8_8 -> uint8_8
val vredmax_uint8_8 : uint8_8 -> uint8_8
val vredmin_uint8_8 : uint8_8 -> uint8_8

(** {9 Functor layer — ARITH modules per concrete type}

    Each module below satisfies [ARITH]. Open one at the use site.
    The compiler inlines through the module — no overhead vs primitives.

    {[
      open Seraph.Neon_varith.Float32x4
      let c = vadd a b          (* = vadd_float32_4 a b *)
      let d = vfma ~acc:c a b   (* = vfma_float32_4 ~acc:c a b *)
    ]} *)

module Float32x4 : ARITH
  with type elt   = seraph_float32
  and  type lanes = seraph_n4
  and  type reg   = q

module Float32x2 : ARITH
  with type elt   = seraph_float32
  and  type lanes = seraph_n2
  and  type reg   = d

module Float64x2 : ARITH
  with type elt   = seraph_float64
  and  type lanes = seraph_n2
  and  type reg   = q

module Int32x4 : ARITH
  with type elt   = seraph_int32
  and  type lanes = seraph_n4
  and  type reg   = q

module Int32x2 : ARITH
  with type elt   = seraph_int32
  and  type lanes = seraph_n2
  and  type reg   = d

module Int16x8 : ARITH
  with type elt   = seraph_int16
  and  type lanes = seraph_n8
  and  type reg   = q

module Int16x4 : ARITH
  with type elt   = seraph_int16
  and  type lanes = seraph_n4
  and  type reg   = d

module Int8x16 : ARITH
  with type elt   = seraph_int8
  and  type lanes = seraph_n16
  and  type reg   = q

module Int8x8 : ARITH
  with type elt   = seraph_int8
  and  type lanes = seraph_n8
  and  type reg   = d

module Uint8x16 : ARITH
  with type elt   = seraph_uint8
  and  type lanes = seraph_n16
  and  type reg   = q

module Uint8x8 : ARITH
  with type elt   = seraph_uint8
  and  type lanes = seraph_n8
  and  type reg   = d
