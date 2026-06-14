(** Seraph — ARM NEON intrinsics for OXCaml

    Neon_vload: Load and store operations.

    Covers:
      vld1  — unit-stride load into a single vector
      vst1  — unit-stride store from a single vector
      vld2/vld3/vld4 — interleaved multi-vector loads
      vst2/vst3/vst4 — interleaved multi-vector stores

    All operations go through [Ptr.t] — an abstract pointer type
    wrapping a [Bytes.t] buffer with an offset and byte length.
    The C stubs receive a raw pointer derived from [Ptr.t].
    Bounds are checked at the OCaml boundary before any FFI call. *)

open Neon_types


(* ------------------------------------------------------------------ *)
(** {1 Pointer type}

    [Ptr.t] is the single entry point for all memory in Seraph.
    It wraps a [Bytes.t] with an offset and a byte length so the
    load/store stubs can do a single bounds check before calling
    into C, rather than trusting the caller's arithmetic.

    You never construct a raw pointer — you always go through
    [Ptr.of_bytes] or [Ptr.of_bigarray], then pass it to a load
    or store function. *)
(* ------------------------------------------------------------------ *)

module Ptr : sig

  type t
  (** Abstract pointer: [Bytes.t] buffer + byte offset + byte length.
      Immutable after construction. *)

  (** [of_bytes buf ~off ~len] wraps [buf] starting at byte offset [off]
      for [len] bytes. Returns [Error Alignment_fault] if [off] is
      negative, [len] is negative, or [off + len > Bytes.length buf]. *)
  val of_bytes
    :  Bytes.t
    -> off:int
    -> len:int
    -> t seraph_result

  (** [of_bytes_exn buf ~off ~len] is [of_bytes] but raises
      [Invalid_argument] on bounds or alignment failure. *)
  val of_bytes_exn
    :  Bytes.t
    -> off:int
    -> len:int
    -> t

  (** [offset p] returns the byte offset into the underlying buffer. *)
  val offset : t -> int

  (** [length p] returns the number of accessible bytes from [offset]. *)
  val length : t -> int

  (** [advance p n] returns a new [Ptr.t] shifted forward by [n] bytes.
      Returns [Error Alignment_fault] if the shift exceeds [length p]. *)
  val advance : t -> int -> t seraph_result

  (** [advance_exn p n] is [advance] but raises [Invalid_argument]. *)
  val advance_exn : t -> int -> t

end

(** {2 Element width helper}

    Load/store stubs need to know how many bytes to read per lane.
    [byte_width elt_bits lanes] computes the total byte count for
    one vector: [elt_bits / 8 * lane_count].

    Used internally by bounds checks — exposed here for testing. *)

val byte_width : elt_bits:int -> lane_count:int -> int


(** {3 vld1 — unit-stride single-vector loads}

    Each function loads [lane_count] contiguous elements from [ptr]
    into a vector register. The pointer must be aligned to the
    element size.

    Naming: [vld1_<elt><lanes><reg>]

    These correspond directly to arm_neon.h:
      vld1q_f32  ->  vld1_float32_4
      vld1_f32   ->  vld1_float32_2
      vld1q_s8   ->  vld1_int8_16
      etc. *)

(** {4 float32} *)

val vld1_float32_4 : Ptr.t -> float32_4 seraph_result
(** Load 4 × float32 (128-bit, q register). Requires 4-byte alignment. *)

val vld1_float32_2 : Ptr.t -> float32_2 seraph_result
(** Load 2 × float32 (64-bit, d register). Requires 4-byte alignment. *)

(** {4 float64} *)

val vld1_float64_2 : Ptr.t -> float64_2 seraph_result
(** Load 2 × float64 (128-bit, q register). Requires 8-byte alignment. *)

val vld1_float64_1 : Ptr.t -> float64_1 seraph_result
(** Load 1 × float64 (64-bit, d register). Requires 8-byte alignment. *)

(** {4 int8} *)

val vld1_int8_16 : Ptr.t -> int8_16 seraph_result
(** Load 16 × int8 (128-bit, q register). No alignment requirement. *)

val vld1_int8_8 : Ptr.t -> int8_8 seraph_result
(** Load 8 × int8 (64-bit, d register). No alignment requirement. *)

(** {4 int16} *)

val vld1_int16_8 : Ptr.t -> int16_8 seraph_result
(** Load 8 × int16 (128-bit, q register). Requires 2-byte alignment. *)

val vld1_int16_4 : Ptr.t -> int16_4 seraph_result
(** Load 4 × int16 (64-bit, d register). Requires 2-byte alignment. *)

(** {4 int32} *)

val vld1_int32_4 : Ptr.t -> int32_4 seraph_result
(** Load 4 × int32 (128-bit, q register). Requires 4-byte alignment. *)

val vld1_int32_2 : Ptr.t -> int32_2 seraph_result
(** Load 2 × int32 (64-bit, d register). Requires 4-byte alignment. *)

(** {4 uint8} *)

val vld1_uint8_16 : Ptr.t -> uint8_16 seraph_result
(** Load 16 × uint8 (128-bit, q register). No alignment requirement. *)

val vld1_uint8_8 : Ptr.t -> uint8_8 seraph_result
(** Load 8 × uint8 (64-bit, d register). No alignment requirement. *)

(** {4 uint16} *)

val vld1_uint16_8 : Ptr.t -> uint16_8 seraph_result
(** Load 8 × uint16 (128-bit, q register). Requires 2-byte alignment. *)

val vld1_uint16_4 : Ptr.t -> uint16_4 seraph_result
(** Load 4 × uint16 (64-bit, d register). Requires 2-byte alignment. *)

(** {4 uint32} *)

val vld1_uint32_4 : Ptr.t -> uint32_4 seraph_result
(** Load 4 × uint32 (128-bit, q register). Requires 4-byte alignment. *)

val vld1_uint32_2 : Ptr.t -> uint32_2 seraph_result
(** Load 2 × uint32 (64-bit, d register). Requires 4-byte alignment. *)


(** {5 vst1 — unit-stride single-vector stores}

    Each function stores a vector's lanes into [len] contiguous bytes
    starting at [ptr]. Same alignment rules as the corresponding vld1. *)

val vst1_float32_4 : Ptr.t -> float32_4 -> unit seraph_result
val vst1_float32_2 : Ptr.t -> float32_2 -> unit seraph_result
val vst1_float64_2 : Ptr.t -> float64_2 -> unit seraph_result
val vst1_float64_1 : Ptr.t -> float64_1 -> unit seraph_result
val vst1_int8_16   : Ptr.t -> int8_16   -> unit seraph_result
val vst1_int8_8    : Ptr.t -> int8_8    -> unit seraph_result
val vst1_int16_8   : Ptr.t -> int16_8   -> unit seraph_result
val vst1_int16_4   : Ptr.t -> int16_4   -> unit seraph_result
val vst1_int32_4   : Ptr.t -> int32_4   -> unit seraph_result
val vst1_int32_2   : Ptr.t -> int32_2   -> unit seraph_result
val vst1_uint8_16  : Ptr.t -> uint8_16  -> unit seraph_result
val vst1_uint8_8   : Ptr.t -> uint8_8   -> unit seraph_result
val vst1_uint16_8  : Ptr.t -> uint16_8  -> unit seraph_result
val vst1_uint16_4  : Ptr.t -> uint16_4  -> unit seraph_result
val vst1_uint32_4  : Ptr.t -> uint32_4  -> unit seraph_result
val vst1_uint32_2  : Ptr.t -> uint32_2  -> unit seraph_result


(** {6 vld2 — interleaved 2-vector loads}

    vld2 loads two vectors with de-interleaved lanes. For example,
    vld2q_f32 on [a0 b0 a1 b1 a2 b2 a3 b3] produces:
      val0 = [a0 a1 a2 a3]
      val1 = [b0 b1 b2 b3]

    Useful for: complex numbers (re/im), stereo audio, Q/K pairs. *)

val vld2_float32_4 : Ptr.t -> (seraph_float32, seraph_n4, q) vec2 seraph_result
val vld2_float32_2 : Ptr.t -> (seraph_float32, seraph_n2, d) vec2 seraph_result
val vld2_int8_16   : Ptr.t -> (seraph_int8,   seraph_n16, q) vec2 seraph_result
val vld2_int8_8    : Ptr.t -> (seraph_int8,    seraph_n8, d) vec2 seraph_result
val vld2_int16_8   : Ptr.t -> (seraph_int16,   seraph_n8, q) vec2 seraph_result
val vld2_int16_4   : Ptr.t -> (seraph_int16,   seraph_n4, d) vec2 seraph_result
val vld2_int32_4   : Ptr.t -> (seraph_int32,   seraph_n4, q) vec2 seraph_result
val vld2_uint8_16  : Ptr.t -> (seraph_uint8,  seraph_n16, q) vec2 seraph_result
val vld2_uint16_8  : Ptr.t -> (seraph_uint16,  seraph_n8, q) vec2 seraph_result
val vld2_uint32_4  : Ptr.t -> (seraph_uint32,  seraph_n4, q) vec2 seraph_result

(** {7 vst2 — interleaved 2-vector stores}

    vst2 re-interleaves two vectors on store. Inverse of vld2. *)

val vst2_float32_4 : Ptr.t -> (seraph_float32, seraph_n4, q) vec2 -> unit seraph_result
val vst2_float32_2 : Ptr.t -> (seraph_float32, seraph_n2, d) vec2 -> unit seraph_result
val vst2_int8_16   : Ptr.t -> (seraph_int8,   seraph_n16, q) vec2 -> unit seraph_result
val vst2_int8_8    : Ptr.t -> (seraph_int8,    seraph_n8, d) vec2 -> unit seraph_result
val vst2_int16_8   : Ptr.t -> (seraph_int16,   seraph_n8, q) vec2 -> unit seraph_result
val vst2_int16_4   : Ptr.t -> (seraph_int16,   seraph_n4, d) vec2 -> unit seraph_result
val vst2_int32_4   : Ptr.t -> (seraph_int32,   seraph_n4, q) vec2 -> unit seraph_result
val vst2_uint8_16  : Ptr.t -> (seraph_uint8,  seraph_n16, q) vec2 -> unit seraph_result
val vst2_uint16_8  : Ptr.t -> (seraph_uint16,  seraph_n8, q) vec2 -> unit seraph_result
val vst2_uint32_4  : Ptr.t -> (seraph_uint32,  seraph_n4, q) vec2 -> unit seraph_result


(* ------------------------------------------------------------------ *)
(** {8 vld3 — interleaved 3-vector loads}

    vld3 de-interleaves three vectors. Classic use case: RGB pixels.
    [r0 g0 b0 r1 g1 b1 ...] → val0=R, val1=G, val2=B *)
(* ------------------------------------------------------------------ *)

val vld3_float32_4 : Ptr.t -> (seraph_float32, seraph_n4, q) vec3 seraph_result
val vld3_int8_16   : Ptr.t -> (seraph_int8,   seraph_n16, q) vec3 seraph_result
val vld3_uint8_16  : Ptr.t -> (seraph_uint8,  seraph_n16, q) vec3 seraph_result
val vld3_int16_8   : Ptr.t -> (seraph_int16,   seraph_n8, q) vec3 seraph_result
val vld3_int32_4   : Ptr.t -> (seraph_int32,   seraph_n4, q) vec3 seraph_result


(* ------------------------------------------------------------------ *)
(** {9 vst3 — interleaved 3-vector stores} *)
(* ------------------------------------------------------------------ *)

val vst3_float32_4 : Ptr.t -> (seraph_float32, seraph_n4, q) vec3 -> unit seraph_result
val vst3_int8_16   : Ptr.t -> (seraph_int8,   seraph_n16, q) vec3 -> unit seraph_result
val vst3_uint8_16  : Ptr.t -> (seraph_uint8,  seraph_n16, q) vec3 -> unit seraph_result
val vst3_int16_8   : Ptr.t -> (seraph_int16,   seraph_n8, q) vec3 -> unit seraph_result
val vst3_int32_4   : Ptr.t -> (seraph_int32,   seraph_n4, q) vec3 -> unit seraph_result


(* ------------------------------------------------------------------ *)
(** {10 vld4 — interleaved 4-vector loads}

    vld4 de-interleaves four vectors. Classic use case: RGBA pixels,
    interleaved Q/K/V/mask in attention. *)
(* ------------------------------------------------------------------ *)

val vld4_float32_4 : Ptr.t -> (seraph_float32, seraph_n4, q) vec4 seraph_result
val vld4_int8_16   : Ptr.t -> (seraph_int8,   seraph_n16, q) vec4 seraph_result
val vld4_uint8_16  : Ptr.t -> (seraph_uint8,  seraph_n16, q) vec4 seraph_result
val vld4_int16_8   : Ptr.t -> (seraph_int16,   seraph_n8, q) vec4 seraph_result
val vld4_int32_4   : Ptr.t -> (seraph_int32,   seraph_n4, q) vec4 seraph_result


(* ------------------------------------------------------------------ *)
(** {11 vst4 — interleaved 4-vector stores} *)
(* ------------------------------------------------------------------ *)

val vst4_float32_4 : Ptr.t -> (seraph_float32, seraph_n4, q) vec4 -> unit seraph_result
val vst4_int8_16   : Ptr.t -> (seraph_int8,   seraph_n16, q) vec4 -> unit seraph_result
val vst4_uint8_16  : Ptr.t -> (seraph_uint8,  seraph_n16, q) vec4 -> unit seraph_result
val vst4_int16_8   : Ptr.t -> (seraph_int16,   seraph_n8, q) vec4 -> unit seraph_result
val vst4_int32_4   : Ptr.t -> (seraph_int32,   seraph_n4, q) vec4 -> unit seraph_result
