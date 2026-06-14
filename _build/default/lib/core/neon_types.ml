open Base
open Bigarray

type d
type q

module type REG = sig
  type t
  val bits : int
  val name : string
end

module type ELT = sig
  type t
  val bits     : int
  val name     : string
  val is_float  : bool
  val is_signed : bool
end

module type LANES = sig
  type t
  val count : int
end

module type WIDEN = sig
  type narrow
  type wide
  val narrow_bits : int
  val wide_bits   : int
end

module Reg = struct
  module D : REG with type t = d = struct
    type t = d
    let bits = 64
    let name = "d"
  end

  module Q : REG with type t = q = struct
    type t = q
    let bits = 128
    let name = "q"
  end
end

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


module Elt = struct
  module Float32 : ELT with type t = seraph_float32 = struct
    type t = seraph_float32
    let bits = 32
    let name = "float32"
    let is_float = true
    let is_signed = true
  end

  module Float64 : ELT with type t = seraph_float64 = struct
    type t = seraph_float64
    let bits = 64
    let name = "float64"
    let is_float = true
    let is_signed = true
  end

  module Int8 : ELT with type t = seraph_int8 = struct
    type t = seraph_int8
    let bits = 8
    let name = "int8"
    let is_float = false
    let is_signed = true
  end

  module Int16 : ELT with type t = seraph_int16 = struct
    type t = seraph_int16
    let bits = 16
    let name = "int16"  (* Fixed copy-paste error *)
    let is_float = false
    let is_signed = true
  end

  module Int32 : ELT with type t = seraph_int32 = struct
    type t = seraph_int32
    let bits = 32
    let name = "int32"
    let is_float = false
    let is_signed = true
  end

  module Int64 : ELT with type t = seraph_int64 = struct
    type t = seraph_int64
    let bits = 64
    let name = "int64"
    let is_float = false
    let is_signed = true
  end

  module Uint8 : ELT with type t = seraph_uint8 = struct
    type t = seraph_uint8
    let bits = 8
    let name = "uint8"
    let is_float = false
    let is_signed = false
  end

  module Uint16 : ELT with type t = seraph_uint16 = struct
    type t = seraph_uint16
    let bits = 16
    let name = "uint16"
    let is_float = false
    let is_signed = false
  end

  module Uint32 : ELT with type t = seraph_uint32 = struct
    type t = seraph_uint32
    let bits = 32
    let name = "uint32"
    let is_float = false
    let is_signed = false
  end

  module Uint64 : ELT with type t = seraph_uint64 = struct
    type t = seraph_uint64
    let bits = 64
    let name = "uint64"
    let is_float = false
    let is_signed = false
  end

  module Poly8 : ELT with type t = seraph_poly8 = struct
    type t = seraph_poly8
    let bits = 8
    let name = "poly8"
    let is_float = false
    let is_signed = false
  end

  module Poly16 : ELT with type t = seraph_poly16 = struct
    type t = seraph_poly16
    let bits = 16
    let name = "poly16"
    let is_float = false
    let is_signed = false
  end
end


type seraph_n1
type seraph_n2
type seraph_n4
type seraph_n8
type seraph_n16

module Lanes = struct
  module N1 : LANES with type t = seraph_n1 = struct
    type t = seraph_n1
    let count = 1
  end

  module N2 : LANES with type t = seraph_n2 = struct
    type t = seraph_n2
    let count = 2
  end

  module N4 : LANES with type t = seraph_n4 = struct
    type t = seraph_n4
    let count = 4
  end

  module N8 : LANES with type t = seraph_n8 = struct
    type t = seraph_n8
    let count = 8
  end

  module N16 : LANES with type t = seraph_n16 = struct
    type t = seraph_n16
    let count = 16
  end
end


type ('elt, 'lanes, 'reg) vec =
  (float, float32_elt, c_layout) Array1.t

type ('lanes, 'reg) mask =
  (int32, int32_elt, c_layout) Array1.t

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

type float32_2 = (seraph_float32, seraph_n2, d) vec
type float32_4 = (seraph_float32, seraph_n4, q) vec
type float64_1 = (seraph_float64, seraph_n1, d) vec
type float64_2 = (seraph_float64, seraph_n2, q) vec
type int8_8 = (seraph_int8, seraph_n8, d) vec
type int8_16 = (seraph_int8, seraph_n16, q) vec
type int16_4 = (seraph_int16, seraph_n4, d) vec
type int16_8 = (seraph_int16, seraph_n8, q) vec
type int32_2 = (seraph_int32, seraph_n2, d) vec
type int32_4 = (seraph_int32, seraph_n4, q) vec
type int64_1 = (seraph_int64, seraph_n1, d) vec
type int64_2 = (seraph_int64, seraph_n2, q) vec
type uint8_8 = (seraph_uint8, seraph_n8, d) vec
type uint8_16 = (seraph_uint8, seraph_n16, q) vec
type uint16_4 = (seraph_uint16, seraph_n4, d) vec
type uint16_8 = (seraph_uint16, seraph_n8, q) vec
type uint32_2 = (seraph_uint32, seraph_n2, d) vec
type uint32_4 = (seraph_uint32, seraph_n4, q) vec
type uint64_1 = (seraph_uint64, seraph_n1, d) vec
type uint64_2 = (seraph_uint64, seraph_n2, q) vec


module Widen = struct
  module I8_I16 : WIDEN with type narrow = seraph_int8 and type wide = seraph_int16 = struct
    type narrow = seraph_int8
    type wide = seraph_int16
    let narrow_bits = 8
    let wide_bits = 16
  end

  module I16_I32 : WIDEN with type narrow = seraph_int16 and type wide = seraph_int32 = struct
    type narrow = seraph_int16
    type wide = seraph_int32
    let narrow_bits = 16
    let wide_bits = 32
  end

  module I32_I64 : WIDEN with type narrow = seraph_int32 and type wide = seraph_int64 = struct
    type narrow = seraph_int32
    type wide = seraph_int64
    let narrow_bits = 32
    let wide_bits = 64
  end

  module U8_U16 : WIDEN with type narrow = seraph_uint8 and type wide = seraph_uint16 = struct
    type narrow = seraph_uint8
    type wide = seraph_uint16
    let narrow_bits = 8
    let wide_bits = 16
  end

  module U16_U32 : WIDEN with type narrow = seraph_uint16 and type wide = seraph_uint32 = struct
    type narrow = seraph_uint16
    type wide = seraph_uint32
    let narrow_bits = 16
    let wide_bits = 32
  end

  module U32_U64 : WIDEN with type narrow = seraph_uint32 and type wide = seraph_uint64 = struct
    type narrow = seraph_uint32
    type wide = seraph_uint64
    let narrow_bits = 32
    let wide_bits = 64
  end
end



type seraph_error =
  | Alignment_fault
  | Lane_index_oob
  | Unsupported_op
  | Ffi_error of string

type 'a seraph_result = ('a, seraph_error) Result.t
