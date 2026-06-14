open Alcotest
open Seraph.Neon_types

let seraph_error_testable =
  testable
    (fun fmt e -> match e with
      | Alignment_fault -> Format.pp_print_string fmt "Alignment_fault"
      | Lane_index_oob  -> Format.pp_print_string fmt "Lane_index_oob"
      | Unsupported_op  -> Format.pp_print_string fmt "Unsupported_op"
      | Ffi_error msg   -> Format.fprintf fmt "Ffi_error(%s)" msg)
    (fun a b -> match a, b with
      | Alignment_fault, Alignment_fault -> true
      | Lane_index_oob,  Lane_index_oob  -> true
      | Unsupported_op,  Unsupported_op  -> true
      | Ffi_error a,     Ffi_error b     -> String.equal a b
      | _,               _               -> false)

let test_reg_d_bits () =
  check int "D.bits = 64" 64 Reg.D.bits

let test_reg_q_bits () =
  check int "Q.bits = 128" 128 Reg.Q.bits

let test_reg_d_name () =
  check string "D.name = d" "d" Reg.D.name

let test_reg_q_name () =
  check string "Q.name = q" "q" Reg.Q.name

let reg_tests = [
  test_case "D bits" `Quick test_reg_d_bits;
  test_case "Q bits" `Quick test_reg_q_bits;
  test_case "D name" `Quick test_reg_d_name;
  test_case "Q name" `Quick test_reg_q_name;
]

let test_elt_bits () =
  check int "Float32.bits" 32 Elt.Float32.bits;
  check int "Float64.bits" 64 Elt.Float64.bits;
  check int "Int8.bits"    8  Elt.Int8.bits;
  check int "Int16.bits"   16 Elt.Int16.bits;
  check int "Int32.bits"   32 Elt.Int32.bits;
  check int "Int64.bits"   64 Elt.Int64.bits;
  check int "Uint8.bits"   8  Elt.Uint8.bits;
  check int "Uint16.bits"  16 Elt.Uint16.bits;
  check int "Uint32.bits"  32 Elt.Uint32.bits;
  check int "Uint64.bits"  64 Elt.Uint64.bits;
  check int "Poly8.bits"   8  Elt.Poly8.bits;
  check int "Poly16.bits"  16 Elt.Poly16.bits

let test_elt_names () =
  check string "Float32.name" "float32" Elt.Float32.name;
  check string "Float64.name" "float64" Elt.Float64.name;
  check string "Int8.name"    "int8"    Elt.Int8.name;
  check string "Int16.name"   "int16"   Elt.Int16.name;
  check string "Int32.name"   "int32"   Elt.Int32.name;
  check string "Int64.name"   "int64"   Elt.Int64.name;
  check string "Uint8.name"   "uint8"   Elt.Uint8.name;
  check string "Uint16.name"  "uint16"  Elt.Uint16.name;
  check string "Uint32.name"  "uint32"  Elt.Uint32.name;
  check string "Uint64.name"  "uint64"  Elt.Uint64.name;
  check string "Poly8.name"   "poly8"   Elt.Poly8.name;
  check string "Poly16.name"  "poly16"  Elt.Poly16.name

let test_elt_is_float () =
  check bool "Float32.is_float = true"  true  Elt.Float32.is_float;
  check bool "Float64.is_float = true"  true  Elt.Float64.is_float;
  check bool "Int8.is_float = false"    false Elt.Int8.is_float;
  check bool "Int32.is_float = false"   false Elt.Int32.is_float;
  check bool "Uint8.is_float = false"   false Elt.Uint8.is_float;
  check bool "Poly8.is_float = false"   false Elt.Poly8.is_float

let test_elt_is_signed () =
  check bool "Float32.is_signed = true"  true  Elt.Float32.is_signed;
  check bool "Float64.is_signed = true"  true  Elt.Float64.is_signed;
  check bool "Int8.is_signed = true"     true  Elt.Int8.is_signed;
  check bool "Int16.is_signed = true"    true  Elt.Int16.is_signed;
  check bool "Int32.is_signed = true"    true  Elt.Int32.is_signed;
  check bool "Int64.is_signed = true"    true  Elt.Int64.is_signed;
  check bool "Uint8.is_signed = false"   false Elt.Uint8.is_signed;
  check bool "Uint16.is_signed = false"  false Elt.Uint16.is_signed;
  check bool "Uint32.is_signed = false"  false Elt.Uint32.is_signed;
  check bool "Uint64.is_signed = false"  false Elt.Uint64.is_signed;
  check bool "Poly8.is_signed = false"   false Elt.Poly8.is_signed;
  check bool "Poly16.is_signed = false"  false Elt.Poly16.is_signed

let elt_tests = [
  test_case "bits"      `Quick test_elt_bits;
  test_case "names"     `Quick test_elt_names;
  test_case "is_float"  `Quick test_elt_is_float;
  test_case "is_signed" `Quick test_elt_is_signed;
]

let test_lanes_counts () =
  check int "N1.count"  1  Lanes.N1.count;
  check int "N2.count"  2  Lanes.N2.count;
  check int "N4.count"  4  Lanes.N4.count;
  check int "N8.count"  8  Lanes.N8.count;
  check int "N16.count" 16 Lanes.N16.count

let lanes_tests = [
  test_case "counts" `Quick test_lanes_counts;
]

let test_widen_narrow_bits () =
  check int "I8_I16.narrow_bits"  8  Widen.I8_I16.narrow_bits;
  check int "I16_I32.narrow_bits" 16 Widen.I16_I32.narrow_bits;
  check int "I32_I64.narrow_bits" 32 Widen.I32_I64.narrow_bits;
  check int "U8_U16.narrow_bits"  8  Widen.U8_U16.narrow_bits;
  check int "U16_U32.narrow_bits" 16 Widen.U16_U32.narrow_bits;
  check int "U32_U64.narrow_bits" 32 Widen.U32_U64.narrow_bits

let test_widen_wide_bits () =
  check int "I8_I16.wide_bits"  16 Widen.I8_I16.wide_bits;
  check int "I16_I32.wide_bits" 32 Widen.I16_I32.wide_bits;
  check int "I32_I64.wide_bits" 64 Widen.I32_I64.wide_bits;
  check int "U8_U16.wide_bits"  16 Widen.U8_U16.wide_bits;
  check int "U16_U32.wide_bits" 32 Widen.U16_U32.wide_bits;
  check int "U32_U64.wide_bits" 64 Widen.U32_U64.wide_bits

let test_widen_invariant () =
  check int "I8_I16:  wide = 2*narrow"
    (2 * Widen.I8_I16.narrow_bits)  Widen.I8_I16.wide_bits;
  check int "I16_I32: wide = 2*narrow"
    (2 * Widen.I16_I32.narrow_bits) Widen.I16_I32.wide_bits;
  check int "I32_I64: wide = 2*narrow"
    (2 * Widen.I32_I64.narrow_bits) Widen.I32_I64.wide_bits;
  check int "U8_U16:  wide = 2*narrow"
    (2 * Widen.U8_U16.narrow_bits)  Widen.U8_U16.wide_bits;
  check int "U16_U32: wide = 2*narrow"
    (2 * Widen.U16_U32.narrow_bits) Widen.U16_U32.wide_bits;
  check int "U32_U64: wide = 2*narrow"
    (2 * Widen.U32_U64.narrow_bits) Widen.U32_U64.wide_bits

let widen_tests = [
  test_case "narrow_bits" `Quick test_widen_narrow_bits;
  test_case "wide_bits"   `Quick test_widen_wide_bits;
  test_case "invariant"   `Quick test_widen_invariant;
]

let test_error_variants () =
  let classify = function
    | Alignment_fault -> "alignment_fault"
    | Lane_index_oob  -> "lane_index_oob"
    | Unsupported_op  -> "unsupported_op"
    | Ffi_error msg   -> "ffi_error:" ^ msg
  in
  check string "Alignment_fault" "alignment_fault" (classify Alignment_fault);
  check string "Lane_index_oob"  "lane_index_oob"  (classify Lane_index_oob);
  check string "Unsupported_op"  "unsupported_op"  (classify Unsupported_op);
  check string "Ffi_error"       "ffi_error:boom"  (classify (Ffi_error "boom"))

let test_seraph_result () =
  let ok  : int seraph_result = Ok 42 in
  let err : int seraph_result = Error Alignment_fault in
  check (result int seraph_error_testable) "Ok 42"
    (Ok 42) ok;
  check (result int seraph_error_testable) "Error Alignment_fault"
    (Error Alignment_fault) err

let error_tests = [
  test_case "error variants" `Quick test_error_variants;
  test_case "seraph_result"  `Quick test_seraph_result;
]

let test_phantom_compile () =
  let accept_float32_4 (_ : float32_4) = () in
  let accept_float32_2 (_ : float32_2) = () in
  let accept_q         (_ : ('e, 'l, q) vec) = () in
  let same_shape       (_ : ('e, 'l, 'r) vec) (_ : ('e, 'l, 'r) vec) = () in

  let check_vec2_fields (v : (seraph_float32, seraph_n4, q) vec2) =
    let _ : float32_4 = v.val0 in
    let _ : float32_4 = v.val1 in ()
  in
  let check_vec3_fields (v : (seraph_float32, seraph_n4, q) vec3) =
    let _ : float32_4 = v.val0 in
    let _ : float32_4 = v.val1 in
    let _ : float32_4 = v.val2 in ()
  in
  let check_vec4_fields (v : (seraph_float32, seraph_n4, q) vec4) =
    let _ : float32_4 = v.val0 in
    let _ : float32_4 = v.val1 in
    let _ : float32_4 = v.val2 in
    let _ : float32_4 = v.val3 in ()
  in
  let check_widen
      (type n w)
      (_ : (module WIDEN with type narrow = n and type wide = w))
    = ()
  in
  check_widen (module Widen.I8_I16 : WIDEN
    with type narrow = seraph_int8  and type wide = seraph_int16);
  check_widen (module Widen.U8_U16 : WIDEN
    with type narrow = seraph_uint8 and type wide = seraph_uint16);

  ignore accept_float32_4; ignore accept_float32_2;
  ignore accept_q; ignore same_shape;
  ignore check_vec2_fields; ignore check_vec3_fields; ignore check_vec4_fields

let phantom_tests = [
  test_case "compile-time constraints" `Quick test_phantom_compile;
]

let () =
  run "Seraph.Neon_types" [
    "Reg",     reg_tests;
    "Elt",     elt_tests;
    "Lanes",   lanes_tests;
    "Widen",   widen_tests;
    "Error",   error_tests;
    "Phantom", phantom_tests;
  ]
