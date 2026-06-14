(** Seraph — ARM NEON intrinsics for OXCaml

    Neon_types: Core type algebra for NEON vector types.

    Every [(elt, lanes, reg) vec] is fully determined at compile time.
    Lane count [lanes] is a type-level nat — mixing a [float32x4] with
    a [float32x2] is a type error, not a runtime fault. *)

(** {1 Register Width} *)

type d
(** 64-bit NEON register (doubleword). *)

type q
(** 128-bit NEON register (quadword). *)

module type REG = sig
  type t

  (** Width in bits: 64 for [d], 128 for [q]. *)
  val bits : int

  (** Short name: ["d"] or ["q"]. *)
  val name : string
end

module Reg : sig
  module D : REG with type t = d
  module Q : REG with type t = q
end


(** {2 Element Types} *)

type seraph_float32
type seraph_float64
type seraph_int8
type seraph_int16
type seraph_int32
type seraph_int64
type seraph_uint8
type seraph_uint16
type seraph_uint32
type seraph_uint64
type seraph_poly8
type seraph_poly16
(** Phantom element type tags. Never instantiated as values. *)

module type ELT = sig
  type t

  (** Width in bits: 8, 16, 32, or 64. *)
  val bits : int

  (** Short name, e.g. ["float32"], ["int8"]. *)
  val name : string

  (** [true] for [float32] and [float64]. *)
  val is_float : bool

  (** [true] for signed integer and float types. *)
  val is_signed : bool
end

module Elt : sig
  module Float32 : ELT with type t = seraph_float32
  module Float64 : ELT with type t = seraph_float64
  module Int8    : ELT with type t = seraph_int8
  module Int16   : ELT with type t = seraph_int16
  module Int32   : ELT with type t = seraph_int32
  module Int64   : ELT with type t = seraph_int64
  module Uint8   : ELT with type t = seraph_uint8
  module Uint16  : ELT with type t = seraph_uint16
  module Uint32  : ELT with type t = seraph_uint32
  module Uint64  : ELT with type t = seraph_uint64
  module Poly8   : ELT with type t = seraph_poly8
  module Poly16  : ELT with type t = seraph_poly16
end

(** {3 Type-level Lane Counts}

    Lane count is statically determined by element width + register width:

    {v
      float32 x d  ->  2 lanes    float32 x q  -> 4 lanes
      float64 x d  ->  1 lane     float64 x q  ->  2 lanes
      int8    x d  ->  8 lanes    int8    x q  -> 16 lanes
      int16   x d  ->  4 lanes    int16   x q  ->  8 lanes
      int32   x d  ->  2 lanes    int32   x q  ->  4 lanes
      int64   x d  ->  1 lane     int64   x q  ->  2 lanes
    v} *)

type seraph_n1
type seraph_n2
type seraph_n4
type seraph_n8
type seraph_n16
(** Phantom type-level natural numbers for lane counts. *)

module type LANES = sig
  type t

  (** Concrete lane count: 1, 2, 4, 8, or 16. *)
  val count : int
end

module Lanes : sig
  module N1  : LANES with type t = seraph_n1
  module N2  : LANES with type t = seraph_n2
  module N4  : LANES with type t = seraph_n4
  module N8  : LANES with type t = seraph_n8
  module N16 : LANES with type t = seraph_n16
end


(** {4 The Core Vector Type}

    [(elt, lanes, reg) vec] is the primary NEON vector type.
    All three parameters are phantom — they exist only to make
    the typechecker reject mismatched operations. *)

type ('elt, 'lanes, 'reg) vec
(** Abstract NEON vector. Fully determined at compile time. *)

(** Concrete aliases matching NEON intrinsic naming exactly. *)

type float32_2 = (seraph_float32, seraph_n2, d) vec
type float32_4 = (seraph_float32, seraph_n4, q) vec
type float64_1 = (seraph_float64, seraph_n1, d) vec
type float64_2 = (seraph_float64, seraph_n2, q) vec
type int8_8 = (seraph_int8,    seraph_n8, d) vec
type int8_16 = (seraph_int8,    seraph_n16, q) vec
type int16_4 = (seraph_int16,   seraph_n4, d) vec
type int16_8   = (seraph_int16,   seraph_n8, q) vec
type int32_2   = (seraph_int32,   seraph_n2, d) vec
type int32_4   = (seraph_int32,   seraph_n4, q) vec
type int64_1   = (seraph_int64,   seraph_n1, d) vec
type int64_2   = (seraph_int64,   seraph_n2, q) vec
type uint8_8   = (seraph_uint8,   seraph_n8, d) vec
type uint8_16  = (seraph_uint8,   seraph_n16, q) vec
type uint16_4  = (seraph_uint16,  seraph_n4, d) vec
type uint16_8  = (seraph_uint16,  seraph_n8, q) vec
type uint32_2  = (seraph_uint32,  seraph_n2, d) vec
type uint32_4  = (seraph_uint32,  seraph_n4, q) vec
type uint64_1  = (seraph_uint64,  seraph_n1, d) vec
type uint64_2  = (seraph_uint64,  seraph_n2, q) vec

(** {5 Multi-vector Types}

    NEON vld2/vld3/vld4 load multiple vectors simultaneously.
    Represented as records so OXCaml can unbox the fields. *)

type ('elt, 'lanes, 'reg) vec2 = {
  val0 : ('elt, 'lanes, 'reg) vec;
  val1 : ('elt, 'lanes, 'reg) vec;
}

type ('elt, 'lanes, 'reg) vec3 = {
  val0 : ('elt, 'lanes, 'reg) vec;
  val1 : ('elt, 'lanes, 'reg) vec;
  val2 : ('elt, 'lanes, 'reg) vec;
}

type ('elt, 'lanes, 'reg) vec4 = {
  val0 : ('elt, 'lanes, 'reg) vec;
  val1 : ('elt, 'lanes, 'reg) vec;
  val2 : ('elt, 'lanes, 'reg) vec;
  val3 : ('elt, 'lanes, 'reg) vec;
}

(** {6 Predicate / Mask Type}

    NEON comparisons return an integer vector with lanes set to
    all-ones (true) or all-zeros (false). No separate mask register
    exists in NEON (unlike SVE). The distinct type is a safety
    convention — it prevents accidentally using an arithmetic result
    as a predicate. *)

type ('lanes, 'reg) mask
(** Comparison result / predicate vector. *)


(** {7 Widening / Narrowing Witness} *)

module type WIDEN = sig
  type narrow
  type wide

  (** Bit width of the narrow element type. *)
  val narrow_bits : int

  (** Bit width of the wide element type. Always [2 * narrow_bits]. *)
  val wide_bits : int
end

module Widen : sig
  module I8_I16  : WIDEN with type narrow = seraph_int8   and type wide = seraph_int16
  module I16_I32 : WIDEN with type narrow = seraph_int16  and type wide = seraph_int32
  module I32_I64 : WIDEN with type narrow = seraph_int32  and type wide = seraph_int64
  module U8_U16  : WIDEN with type narrow = seraph_uint8  and type wide = seraph_uint16
  module U16_U32 : WIDEN with type narrow = seraph_uint16 and type wide = seraph_uint32
  module U32_U64 : WIDEN with type narrow = seraph_uint32 and type wide = seraph_uint64
end

(** {8 Error Type} *)

type seraph_error =
  | Alignment_fault
    (** Pointer not aligned to element width. *)
  | Lane_index_oob
    (** [vget_lane] / [vset_lane] index out of range. *)
  | Unsupported_op
    (** Operation not available on this NEON variant. *)
  | Ffi_error of string
    (** C FFI layer returned an unexpected error. *)

type 'a seraph_result = ('a, seraph_error) result
