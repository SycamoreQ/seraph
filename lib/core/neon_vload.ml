open Base
open Neon_types

module Ptr = struct
  type t = { buf : Bytes.t; off : int; len : int; }

  let of_bytes buf ~off ~len =
    if off < 0 || len < 0 || (off + len) > Bytes.length buf then Error Alignment_fault
    else Ok { buf; off; len }

  let of_bytes_exn buf ~off ~len =
    match of_bytes buf ~off ~len with
    | Ok p -> p
    | Error _ -> invalid_arg "Ptr.of_bytes_exn out of bounds"

  let buffer p = p.buf
  let offset p = p.off
  let length p = p.len

  let advance p n =
    if n < 0 || n > p.len then Error Alignment_fault
    else Ok { p with off = p.off + n; len = p.len - n }

  let advance_exn p n =
      match advance p n with
      | Ok p -> p
      | Error _ -> invalid_arg "Ptr.advance_exn: out of bounds"
  end

let byte_width ~elt_bits ~lane_count = (elt_bits / 8) * lane_count

let check_align ptr elt_size =
  if elt_size = 1 then Ok ()
  else if (Ptr.offset ptr) % elt_size <> 0 then Error Alignment_fault
  else Ok ()

let check_bounds ptr bytes =
  if Ptr.length ptr < bytes then Error (Ffi_error (Printf.sprintf "buffer too small: need %d bytes, have %d" bytes (Ptr.length ptr)))
  else Ok ()

let check ptr ~elt_bits ~lane_count =
  let elt_bytes = elt_bits / 8 in
  let total = byte_width ~elt_bits ~lane_count in
  match check_align ptr elt_bytes with
  | Error e -> Error e
  | Ok () -> check_bounds ptr total

external vld1q_f32_stub : Bytes.t -> int -> float32_4 = "caml_seraph_vld1q_f32"
external vld1_f32_stub : Bytes.t -> int -> float32_2 = "caml_seraph_vld1_f32"
external vld1q_f64_stub : Bytes.t -> int -> float64_2 = "caml_seraph_vld1q_f64"
external vld1_f64_stub : Bytes.t -> int -> float64_1 = "caml_seraph_vld1_f64"
external vld1q_s8_stub : Bytes.t -> int -> int8_16 = "caml_seraph_vld1q_s8"
external vld1_s8_stub : Bytes.t -> int -> int8_8 = "caml_seraph_vld1_s8"
external vld1q_s16_stub : Bytes.t -> int -> int16_8 = "caml_seraph_vld1q_s16"
external vld1_s16_stub : Bytes.t -> int -> int16_4 = "caml_seraph_vld1_s16"
external vld1q_s32_stub : Bytes.t -> int -> int32_4 = "caml_seraph_vld1q_s32"
external vld1_s32_stub : Bytes.t -> int -> int32_2 = "caml_seraph_vld1_s32"
external vld1q_u8_stub : Bytes.t -> int -> uint8_16 = "caml_seraph_vld1q_u8"
external vld1_u8_stub : Bytes.t -> int -> uint8_8 = "caml_seraph_vld1_u8"
external vld1q_u16_stub : Bytes.t -> int -> uint16_8 = "caml_seraph_vld1q_u16"
external vld1_u16_stub : Bytes.t -> int -> uint16_4 = "caml_seraph_vld1_u16"
external vld1q_u32_stub : Bytes.t -> int -> uint32_4 = "caml_seraph_vld1q_u32"
external vld1_u32_stub : Bytes.t -> int -> uint32_2 = "caml_seraph_vld1_u32"

let execute_load ptr ~elt_bits ~lane_count stub =
  match check ptr ~elt_bits ~lane_count with
  | Error e -> Error e
  | Ok () -> Ok (stub (Ptr.buffer ptr) (Ptr.offset ptr))

let execute_load_n ptr ~elt_bits ~lane_count ~factor stub =
  match check ptr ~elt_bits ~lane_count:(lane_count * factor) with
  | Error e -> Error e
  | Ok () -> Ok (stub (Ptr.buffer ptr) (Ptr.offset ptr))

let execute_store_n ptr vec ~elt_bits ~lane_count ~factor stub =
  match check ptr ~elt_bits ~lane_count:(lane_count * factor) with
  | Error e -> Error e
  | Ok () -> stub (Ptr.buffer ptr) (Ptr.offset ptr) vec; Ok ()

let vld1_float32_4 ptr = execute_load ptr ~elt_bits:32 ~lane_count:4 vld1q_f32_stub
let vld1_float32_2 ptr = execute_load ptr ~elt_bits:32 ~lane_count:2 vld1_f32_stub
let vld1_float64_2 ptr = execute_load ptr ~elt_bits:64 ~lane_count:2 vld1q_f64_stub
let vld1_float64_1 ptr = execute_load ptr ~elt_bits:64 ~lane_count:1 vld1_f64_stub
let vld1_int8_16 ptr = execute_load ptr ~elt_bits:8 ~lane_count:16 vld1q_s8_stub
let vld1_int8_8 ptr = execute_load ptr ~elt_bits:8 ~lane_count:8 vld1_s8_stub
let vld1_int16_8 ptr = execute_load ptr ~elt_bits:16 ~lane_count:8 vld1q_s16_stub
let vld1_int16_4 ptr = execute_load ptr ~elt_bits:16 ~lane_count:4 vld1_s16_stub
let vld1_int32_4 ptr = execute_load ptr ~elt_bits:32 ~lane_count:4 vld1q_s32_stub
let vld1_int32_2 ptr = execute_load ptr ~elt_bits:32 ~lane_count:2 vld1_s32_stub
let vld1_uint8_16 ptr = execute_load ptr ~elt_bits:8 ~lane_count:16 vld1q_u8_stub
let vld1_uint8_8 ptr = execute_load ptr ~elt_bits:8 ~lane_count:8 vld1_u8_stub
let vld1_uint16_8 ptr = execute_load ptr ~elt_bits:16 ~lane_count:8 vld1q_u16_stub
let vld1_uint16_4 ptr = execute_load ptr ~elt_bits:16 ~lane_count:4 vld1_u16_stub
let vld1_uint32_4 ptr = execute_load ptr ~elt_bits:32 ~lane_count:4 vld1q_u32_stub
let vld1_uint32_2 ptr = execute_load ptr ~elt_bits:32 ~lane_count:2 vld1_u32_stub

external vst1q_f32_stub : Bytes.t -> int -> float32_4 -> unit = "caml_seraph_vst1q_f32"
external vst1_f32_stub : Bytes.t -> int -> float32_2 -> unit = "caml_seraph_vst1_f32"
external vst1q_f64_stub : Bytes.t -> int -> float64_2 -> unit = "caml_seraph_vst1q_f64"
external vst1_f64_stub : Bytes.t -> int -> float64_1 -> unit = "caml_seraph_vst1_f64"
external vst1q_s8_stub : Bytes.t -> int -> int8_16 -> unit = "caml_seraph_vst1q_s8"
external vst1_s8_stub : Bytes.t -> int -> int8_8 -> unit = "caml_seraph_vst1_s8"
external vst1q_s16_stub : Bytes.t -> int -> int16_8 -> unit = "caml_seraph_vst1q_s16"
external vst1_s16_stub : Bytes.t -> int -> int16_4 -> unit = "caml_seraph_vst1_s16"
external vst1q_s32_stub : Bytes.t -> int -> int32_4 -> unit = "caml_seraph_vst1q_s32"
external vst1_s32_stub : Bytes.t -> int -> int32_2 -> unit = "caml_seraph_vst1_s32"
external vst1q_u8_stub : Bytes.t -> int -> uint8_16 -> unit = "caml_seraph_vst1q_u8"
external vst1_u8_stub : Bytes.t -> int -> uint8_8 -> unit = "caml_seraph_vst1_u8"
external vst1q_u16_stub : Bytes.t -> int -> uint16_8 -> unit = "caml_seraph_vst1q_u16"
external vst1_u16_stub : Bytes.t -> int -> uint16_4 -> unit = "caml_seraph_vst1_u16"
external vst1q_u32_stub : Bytes.t -> int -> uint32_4 -> unit = "caml_seraph_vst1q_u32"
external vst1_u32_stub : Bytes.t -> int -> uint32_2 -> unit = "caml_seraph_vst1_u32"

let execute_store ptr vec ~elt_bits ~lane_count stub =
  match check ptr ~elt_bits ~lane_count with
  | Error e -> Error e
  | Ok () -> stub (Ptr.buffer ptr) (Ptr.offset ptr) vec; Ok ()

let vst1_float32_4 ptr vec = execute_store ptr vec ~elt_bits:32 ~lane_count:4 vst1q_f32_stub
let vst1_float32_2 ptr vec = execute_store ptr vec ~elt_bits:32 ~lane_count:2 vst1_f32_stub
let vst1_float64_2 ptr vec = execute_store ptr vec ~elt_bits:64 ~lane_count:2 vst1q_f64_stub
let vst1_float64_1 ptr vec = execute_store ptr vec ~elt_bits:64 ~lane_count:1 vst1_f64_stub
let vst1_int8_16 ptr vec = execute_store ptr vec ~elt_bits:8 ~lane_count:16 vst1q_s8_stub
let vst1_int8_8 ptr vec = execute_store ptr vec ~elt_bits:8 ~lane_count:8 vst1_s8_stub
let vst1_int16_8 ptr vec = execute_store ptr vec ~elt_bits:16 ~lane_count:8 vst1q_s16_stub
let vst1_int16_4 ptr vec = execute_store ptr vec ~elt_bits:16 ~lane_count:4 vst1_s16_stub
let vst1_int32_4 ptr vec = execute_store ptr vec ~elt_bits:32 ~lane_count:4 vst1q_s32_stub
let vst1_int32_2 ptr vec = execute_store ptr vec ~elt_bits:32 ~lane_count:2 vst1_s32_stub
let vst1_uint8_16 ptr vec = execute_store ptr vec ~elt_bits:8 ~lane_count:16 vst1q_u8_stub
let vst1_uint8_8 ptr vec = execute_store ptr vec ~elt_bits:8 ~lane_count:8 vst1_u8_stub
let vst1_uint16_8 ptr vec = execute_store ptr vec ~elt_bits:16 ~lane_count:8 vst1q_u16_stub
let vst1_uint16_4 ptr vec = execute_store ptr vec ~elt_bits:16 ~lane_count:4 vst1_u16_stub
let vst1_uint32_4 ptr vec = execute_store ptr vec ~elt_bits:32 ~lane_count:4 vst1q_u32_stub
let vst1_uint32_2 ptr vec = execute_store ptr vec ~elt_bits:32 ~lane_count:2 vst1_u32_stub

external vld2q_f32_stub : Bytes.t -> int -> (seraph_float32, seraph_n4, q) vec2 = "caml_seraph_vld2q_f32"
external vld2_f32_stub : Bytes.t -> int -> (seraph_float32, seraph_n2, d) vec2 = "caml_seraph_vld2_f32"
external vld2q_s8_stub : Bytes.t -> int -> (seraph_int8, seraph_n16, q) vec2 = "caml_seraph_vld2q_s8"
external vld2_s8_stub : Bytes.t -> int -> (seraph_int8, seraph_n8, d) vec2 = "caml_seraph_vld2_s8"
external vld2q_s16_stub : Bytes.t -> int -> (seraph_int16, seraph_n8, q) vec2 = "caml_seraph_vld2q_s16"
external vld2_s16_stub : Bytes.t -> int -> (seraph_int16, seraph_n4, d) vec2 = "caml_seraph_vld2_s16"
external vld2q_s32_stub : Bytes.t -> int -> (seraph_int32, seraph_n4, q) vec2 = "caml_seraph_vld2q_s32"
external vld2q_u8_stub : Bytes.t -> int -> (seraph_uint8, seraph_n16, q) vec2 = "caml_seraph_vld2q_u8"
external vld2q_u16_stub : Bytes.t -> int -> (seraph_uint16, seraph_n8, q) vec2 = "caml_seraph_vld2q_u16"
external vld2q_u32_stub : Bytes.t -> int -> (seraph_uint32, seraph_n4, q) vec2 = "caml_seraph_vld2q_u32"


let vld2_float32_4 ptr = execute_load_n ptr ~elt_bits:32 ~lane_count:4 ~factor:2 vld2q_f32_stub
let vld2_float32_2 ptr = execute_load_n ptr ~elt_bits:32 ~lane_count:2 ~factor:2 vld2_f32_stub
let vld2_int8_16 ptr = execute_load_n ptr ~elt_bits:8 ~lane_count:16 ~factor:2 vld2q_s8_stub
let vld2_int8_8 ptr = execute_load_n ptr ~elt_bits:8 ~lane_count:8 ~factor:2 vld2_s8_stub
let vld2_int16_8 ptr = execute_load_n ptr ~elt_bits:16 ~lane_count:8 ~factor:2 vld2q_s16_stub
let vld2_int16_4 ptr = execute_load_n ptr ~elt_bits:16 ~lane_count:4 ~factor:2 vld2_s16_stub
let vld2_int32_4 ptr = execute_load_n ptr ~elt_bits:32 ~lane_count:4 ~factor:2 vld2q_s32_stub
let vld2_uint8_16 ptr = execute_load_n ptr ~elt_bits:8 ~lane_count:16 ~factor:2 vld2q_u8_stub
let vld2_uint16_8 ptr = execute_load_n ptr ~elt_bits:16 ~lane_count:8 ~factor:2 vld2q_u16_stub
let vld2_uint32_4 ptr = execute_load_n ptr ~elt_bits:32 ~lane_count:4 ~factor:2 vld2q_u32_stub


external vst2q_f32_stub : Bytes.t -> int -> (seraph_float32, seraph_n4, q) vec2 -> unit = "caml_seraph_vst2q_f32"
external vst2_f32_stub : Bytes.t -> int -> (seraph_float32, seraph_n2, d) vec2 -> unit = "caml_seraph_vst2_f32"
external vst2q_s8_stub : Bytes.t -> int -> (seraph_int8, seraph_n16, q) vec2 -> unit = "caml_seraph_vst2q_s8"
external vst2_s8_stub : Bytes.t -> int -> (seraph_int8, seraph_n8, d) vec2 -> unit = "caml_seraph_vst2_s8"
external vst2q_s16_stub : Bytes.t -> int -> (seraph_int16, seraph_n8, q) vec2 -> unit = "caml_seraph_vst2q_s16"
external vst2_s16_stub : Bytes.t -> int -> (seraph_int16, seraph_n4, d) vec2 -> unit = "caml_seraph_vst2_s16"
external vst2q_s32_stub : Bytes.t -> int -> (seraph_int32, seraph_n4, q) vec2 -> unit = "caml_seraph_vst2q_s32"
external vst2q_u8_stub : Bytes.t -> int -> (seraph_uint8, seraph_n16, q) vec2 -> unit = "caml_seraph_vst2q_u8"
external vst2q_u16_stub : Bytes.t -> int -> (seraph_uint16, seraph_n8, q) vec2 -> unit = "caml_seraph_vst2q_u16"
external vst2q_u32_stub : Bytes.t -> int -> (seraph_uint32, seraph_n4, q) vec2 -> unit = "caml_seraph_vst2q_u32"

external vld3q_f32_stub : Bytes.t -> int -> (seraph_float32, seraph_n4, q) vec3 = "caml_seraph_vld3q_f32"
external vst3q_f32_stub : Bytes.t -> int -> (seraph_float32, seraph_n4, q) vec3 -> unit = "caml_seraph_vst3q_f32"
external vld3q_s8_stub : Bytes.t -> int -> (seraph_int8, seraph_n16, q) vec3 = "caml_seraph_vld3q_s8"
external vst3q_s8_stub : Bytes.t -> int -> (seraph_int8, seraph_n16, q) vec3 -> unit = "caml_seraph_vst3q_s8"
external vld3q_u8_stub : Bytes.t -> int -> (seraph_uint8, seraph_n16, q) vec3 = "caml_seraph_vld3q_u8"
external vst3q_u8_stub : Bytes.t -> int -> (seraph_uint8, seraph_n16, q) vec3 -> unit = "caml_seraph_vst3q_u8"
external vld3q_s16_stub : Bytes.t -> int -> (seraph_int16, seraph_n8, q) vec3 = "caml_seraph_vld3q_s16"
external vst3q_s16_stub : Bytes.t -> int -> (seraph_int16, seraph_n8, q) vec3 -> unit = "caml_seraph_vst3q_s16"
external vld3q_s32_stub : Bytes.t -> int -> (seraph_int32, seraph_n4, q) vec3 = "caml_seraph_vld3q_s32"
external vst3q_s32_stub : Bytes.t -> int -> (seraph_int32, seraph_n4, q) vec3 -> unit = "caml_seraph_vst3q_s32"

external vld4q_f32_stub : Bytes.t -> int -> (seraph_float32, seraph_n4, q) vec4 = "caml_seraph_vld4q_f32"
external vst4q_f32_stub : Bytes.t -> int -> (seraph_float32, seraph_n4, q) vec4 -> unit = "caml_seraph_vst4q_f32"
external vld4q_s8_stub : Bytes.t -> int -> (seraph_int8, seraph_n16, q) vec4 = "caml_seraph_vld4q_s8"
external vst4q_s8_stub : Bytes.t -> int -> (seraph_int8, seraph_n16, q) vec4 -> unit = "caml_seraph_vst4q_s8"
external vld4q_u8_stub : Bytes.t -> int -> (seraph_uint8, seraph_n16, q) vec4 = "caml_seraph_vld4q_u8"
external vst4q_u8_stub : Bytes.t -> int -> (seraph_uint8, seraph_n16, q) vec4 -> unit = "caml_seraph_vst4q_u8"
external vld4q_s16_stub : Bytes.t -> int -> (seraph_int16, seraph_n8, q) vec4 = "caml_seraph_vld4q_s16"
external vst4q_s16_stub : Bytes.t -> int -> (seraph_int16, seraph_n8, q) vec4 -> unit = "caml_seraph_vst4q_s16"
external vld4q_s32_stub : Bytes.t -> int -> (seraph_int32, seraph_n4, q) vec4 = "caml_seraph_vld4q_s32"
external vst4q_s32_stub : Bytes.t -> int -> (seraph_int32, seraph_n4, q) vec4 -> unit = "caml_seraph_vst4q_s32"

let vst2_float32_4 ptr vec = execute_store_n ptr vec ~elt_bits:32 ~lane_count:4 ~factor:2 vst2q_f32_stub
let vst2_float32_2 ptr vec = execute_store_n ptr vec ~elt_bits:32 ~lane_count:2 ~factor:2 vst2_f32_stub
let vst2_int8_16 ptr vec = execute_store_n ptr vec ~elt_bits:8 ~lane_count:16 ~factor:2 vst2q_s8_stub
let vst2_int8_8 ptr vec = execute_store_n ptr vec ~elt_bits:8 ~lane_count:8 ~factor:2 vst2_s8_stub
let vst2_int16_8 ptr vec = execute_store_n ptr vec ~elt_bits:16 ~lane_count:8 ~factor:2 vst2q_s16_stub
let vst2_int16_4 ptr vec = execute_store_n ptr vec ~elt_bits:16 ~lane_count:4 ~factor:2 vst2_s16_stub
let vst2_int32_4 ptr vec = execute_store_n ptr vec ~elt_bits:32 ~lane_count:4 ~factor:2 vst2q_s32_stub
let vst2_uint8_16 ptr vec = execute_store_n ptr vec ~elt_bits:8 ~lane_count:16 ~factor:2 vst2q_u8_stub
let vst2_uint16_8 ptr vec = execute_store_n ptr vec ~elt_bits:16 ~lane_count:8 ~factor:2 vst2q_u16_stub
let vst2_uint32_4 ptr vec = execute_store_n ptr vec ~elt_bits:32 ~lane_count:4 ~factor:2 vst2q_u32_stub

let vld3_float32_4 ptr = execute_load_n ptr ~elt_bits:32 ~lane_count:4 ~factor:3 vld3q_f32_stub
let vld3_int8_16 ptr = execute_load_n ptr ~elt_bits:8 ~lane_count:16 ~factor:3 vld3q_s8_stub
let vld3_uint8_16 ptr = execute_load_n ptr ~elt_bits:8 ~lane_count:16 ~factor:3 vld3q_u8_stub
let vld3_int16_8 ptr = execute_load_n ptr ~elt_bits:16 ~lane_count:8 ~factor:3 vld3q_s16_stub
let vld3_int32_4 ptr = execute_load_n ptr ~elt_bits:32 ~lane_count:4 ~factor:3 vld3q_s32_stub

let vst3_float32_4 ptr vec = execute_store_n ptr vec ~elt_bits:32 ~lane_count:4 ~factor:3 vst3q_f32_stub
let vst3_int8_16 ptr vec = execute_store_n ptr vec ~elt_bits:8 ~lane_count:16 ~factor:3 vst3q_s8_stub
let vst3_uint8_16 ptr vec = execute_store_n ptr vec ~elt_bits:8 ~lane_count:16 ~factor:3 vst3q_u8_stub
let vst3_int16_8 ptr vec = execute_store_n ptr vec ~elt_bits:16 ~lane_count:8 ~factor:3 vst3q_s16_stub
let vst3_int32_4 ptr vec = execute_store_n ptr vec ~elt_bits:32 ~lane_count:4 ~factor:3 vst3q_s32_stub

let vld4_float32_4 ptr = execute_load_n ptr ~elt_bits:32 ~lane_count:4 ~factor:4 vld4q_f32_stub
let vld4_int8_16 ptr = execute_load_n ptr ~elt_bits:8 ~lane_count:16 ~factor:4 vld4q_s8_stub
let vld4_uint8_16 ptr = execute_load_n ptr ~elt_bits:8 ~lane_count:16 ~factor:4 vld4q_u8_stub
let vld4_int16_8 ptr = execute_load_n ptr ~elt_bits:16 ~lane_count:8 ~factor:4 vld4q_s16_stub
let vld4_int32_4 ptr = execute_load_n ptr ~elt_bits:32 ~lane_count:4 ~factor:4 vld4q_s32_stub

let vst4_float32_4 ptr vec = execute_store_n ptr vec ~elt_bits:32 ~lane_count:4 ~factor:4 vst4q_f32_stub
let vst4_int8_16 ptr vec = execute_store_n ptr vec ~elt_bits:8 ~lane_count:16 ~factor:4 vst4q_s8_stub
let vst4_uint8_16 ptr vec = execute_store_n ptr vec ~elt_bits:8 ~lane_count:16 ~factor:4 vst4q_u8_stub
let vst4_int16_8 ptr vec = execute_store_n ptr vec ~elt_bits:16 ~lane_count:8 ~factor:4 vst4q_s16_stub
let vst4_int32_4 ptr vec = execute_store_n ptr vec ~elt_bits:32 ~lane_count:4 ~factor:4 vst4q_s32_stub
