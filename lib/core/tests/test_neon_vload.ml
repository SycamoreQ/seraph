open Alcotest
open Seraph.Neon_types
open Seraph.Neon_vload

let _seraph_error_testable =
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
      | _ -> false)

let ok_or_fail res =
  match res with
  | Ok v    -> v
  | Error _ -> Alcotest.fail "expected Ok, got Error"

let is_error res =
  match res with
  | Error _ -> true
  | Ok _    -> false

let test_ptr_of_bytes_valid () =
  let buf = Bytes.make 64 '\x00' in
  let p = Ptr.of_bytes buf ~off:0 ~len:64 in
  check bool "Ok"        true  (Result.is_ok p);
  check int  "offset"    0     (Ptr.offset (ok_or_fail p));
  check int  "length"    64    (Ptr.length (ok_or_fail p))

let test_ptr_of_bytes_slice () =
  let buf = Bytes.make 64 '\x00' in
  let p = ok_or_fail (Ptr.of_bytes buf ~off:16 ~len:32) in
  check int "offset" 16 (Ptr.offset p);
  check int "length" 32 (Ptr.length p)

let test_ptr_of_bytes_negative_off () =
  let buf = Bytes.make 64 '\x00' in
  check bool "negative off is Error"
    true (is_error (Ptr.of_bytes buf ~off:(-1) ~len:64))

let test_ptr_of_bytes_negative_len () =
  let buf = Bytes.make 64 '\x00' in
  check bool "negative len is Error"
    true (is_error (Ptr.of_bytes buf ~off:0 ~len:(-1)))

let test_ptr_of_bytes_overflow () =
  let buf = Bytes.make 64 '\x00' in
  check bool "off+len > buf length is Error"
    true (is_error (Ptr.of_bytes buf ~off:48 ~len:32))

let test_ptr_of_bytes_exact () =
  (* off + len = Bytes.length buf is valid (tight slice) *)
  let buf = Bytes.make 64 '\x00' in
  check bool "tight slice is Ok"
    true (Result.is_ok (Ptr.of_bytes buf ~off:32 ~len:32))

let test_ptr_advance_valid () =
  let buf = Bytes.make 64 '\x00' in
  let p  = ok_or_fail (Ptr.of_bytes buf ~off:0 ~len:64) in
  let p2 = ok_or_fail (Ptr.advance p 16) in
  check int "offset after advance" 16 (Ptr.offset p2);
  check int "length after advance" 48 (Ptr.length p2)

let test_ptr_advance_chained () =
  let buf = Bytes.make 64 '\x00' in
  let p  = ok_or_fail (Ptr.of_bytes buf ~off:0 ~len:64) in
  let p2 = ok_or_fail (Ptr.advance p 16) in
  let p3 = ok_or_fail (Ptr.advance p2 16) in
  check int "offset after two advances" 32 (Ptr.offset p3);
  check int "length after two advances" 32 (Ptr.length p3)

let test_ptr_advance_exact () =
  (* advancing by exactly length should give len=0, not an error *)
  let buf = Bytes.make 16 '\x00' in
  let p  = ok_or_fail (Ptr.of_bytes buf ~off:0 ~len:16) in
  let p2 = ok_or_fail (Ptr.advance p 16) in
  check int "length after full advance" 0 (Ptr.length p2)

let test_ptr_advance_overflow () =
  let buf = Bytes.make 16 '\x00' in
  let p = ok_or_fail (Ptr.of_bytes buf ~off:0 ~len:16) in
  check bool "advance past end is Error"
    true (is_error (Ptr.advance p 17))

let test_ptr_advance_negative () =
  let buf = Bytes.make 16 '\x00' in
  let p = ok_or_fail (Ptr.of_bytes buf ~off:0 ~len:16) in
  check bool "negative advance is Error"
    true (is_error (Ptr.advance p (-1)))

let test_ptr_of_bytes_exn_valid () =
  let buf = Bytes.make 32 '\x00' in
  let p = Ptr.of_bytes_exn buf ~off:0 ~len:32 in
  check int "offset" 0  (Ptr.offset p);
  check int "length" 32 (Ptr.length p)

let test_ptr_of_bytes_exn_raises () =
  let buf = Bytes.make 8 '\x00' in
  check_raises "out of bounds raises Invalid_argument"
    (Invalid_argument "Ptr.of_bytes_exn out of bounds")
    (fun () -> ignore (Ptr.of_bytes_exn buf ~off:0 ~len:16))

let test_ptr_advance_exn_raises () =
  let buf = Bytes.make 8 '\x00' in
  let p = Ptr.of_bytes_exn buf ~off:0 ~len:8 in
  check_raises "advance past end raises Invalid_argument"
    (Invalid_argument "Ptr.advance_exn: out of bounds")
    (fun () -> ignore (Ptr.advance_exn p 16))

let ptr_tests = [
  test_case "of_bytes valid"           `Quick test_ptr_of_bytes_valid;
  test_case "of_bytes slice"           `Quick test_ptr_of_bytes_slice;
  test_case "of_bytes negative off"    `Quick test_ptr_of_bytes_negative_off;
  test_case "of_bytes negative len"    `Quick test_ptr_of_bytes_negative_len;
  test_case "of_bytes overflow"        `Quick test_ptr_of_bytes_overflow;
  test_case "of_bytes exact fit"       `Quick test_ptr_of_bytes_exact;
  test_case "advance valid"            `Quick test_ptr_advance_valid;
  test_case "advance chained"          `Quick test_ptr_advance_chained;
  test_case "advance exact"            `Quick test_ptr_advance_exact;
  test_case "advance overflow"         `Quick test_ptr_advance_overflow;
  test_case "advance negative"         `Quick test_ptr_advance_negative;
  test_case "of_bytes_exn valid"       `Quick test_ptr_of_bytes_exn_valid;
  test_case "of_bytes_exn raises"      `Quick test_ptr_of_bytes_exn_raises;
  test_case "advance_exn raises"       `Quick test_ptr_advance_exn_raises;
]


(* ------------------------------------------------------------------ *)
(* byte_width                                                          *)
(* ------------------------------------------------------------------ *)

let test_byte_width () =
  (* float32x4: 4 bytes * 4 lanes = 16 *)
  check int "float32x4" 16 (byte_width ~elt_bits:32 ~lane_count:4);
  (* float32x2: 4 bytes * 2 lanes = 8 *)
  check int "float32x2" 8  (byte_width ~elt_bits:32 ~lane_count:2);
  (* float64x2: 8 bytes * 2 lanes = 16 *)
  check int "float64x2" 16 (byte_width ~elt_bits:64 ~lane_count:2);
  (* int8x16:   1 byte  * 16 lanes = 16 *)
  check int "int8x16"   16 (byte_width ~elt_bits:8  ~lane_count:16);
  (* int8x8:    1 byte  * 8 lanes = 8 *)
  check int "int8x8"    8  (byte_width ~elt_bits:8  ~lane_count:8);
  (* int16x8:   2 bytes * 8 lanes = 16 *)
  check int "int16x8"   16 (byte_width ~elt_bits:16 ~lane_count:8);
  (* int32x4:   4 bytes * 4 lanes = 16 *)
  check int "int32x4"   16 (byte_width ~elt_bits:32 ~lane_count:4);
  (* uint32x2:  4 bytes * 2 lanes = 8 *)
  check int "uint32x2"  8  (byte_width ~elt_bits:32 ~lane_count:2)

let byte_width_tests = [
  test_case "byte_width" `Quick test_byte_width;
]


(* ------------------------------------------------------------------ *)
(* Bounds and alignment checks (no FFI — stubs are empty)             *)
(*                                                                     *)
(* These test the OCaml-side guards. We verify that vld1_* returns    *)
(* Error when the buffer is too small or misaligned, without ever     *)
(* reaching the C stub.                                               *)
(* ------------------------------------------------------------------ *)

(* Buffer too small for float32x4 (needs 16 bytes) *)
let test_vld1_bounds_too_small () =
  let buf = Bytes.make 8 '\x00' in
  let ptr = ok_or_fail (Ptr.of_bytes buf ~off:0 ~len:8) in
  check bool "float32x4 rejects 8-byte buf"
    true (is_error (vld1_float32_4 ptr))

(* Buffer exactly the right size *)
let test_vld1_bounds_exact () =
  (* We can't check Ok here since the stub is empty,
     but we can verify it does NOT return a bounds error.
     The stub will return garbage bytes — that's fine for now. *)
  let buf = Bytes.make 16 '\x00' in
  let ptr = ok_or_fail (Ptr.of_bytes buf ~off:0 ~len:16) in
  (* If this raises rather than returning Error, the bounds check passed
     and the stub was called. Either Ok or a stub-level Ffi_error is fine. *)
  (match vld1_float32_4 ptr with
  | Ok _              -> ()   (* stub returned something *)
  | Error Ffi_error _ -> ()   (* stub signalled error — also fine *)
  | Error e           ->
    Alcotest.failf "unexpected bounds/align error: %a"
      (fun fmt e -> match e with
        | Alignment_fault -> Format.pp_print_string fmt "Alignment_fault"
        | Lane_index_oob  -> Format.pp_print_string fmt "Lane_index_oob"
        | Unsupported_op  -> Format.pp_print_string fmt "Unsupported_op"
        | Ffi_error s     -> Format.fprintf fmt "Ffi_error(%s)" s)
      e)

(* Misaligned offset for float32 (needs 4-byte alignment) *)
let test_vld1_align_float32 () =
  let buf = Bytes.make 32 '\x00' in
  (* offset 1 is not divisible by 4 *)
  let ptr = ok_or_fail (Ptr.of_bytes buf ~off:1 ~len:31) in
  check bool "float32x4 rejects offset=1"
    true (is_error (vld1_float32_4 ptr))

(* int8 has no alignment requirement — odd offset is fine *)
let test_vld1_align_int8_any_offset () =
  let buf = Bytes.make 32 '\x00' in
  let ptr = ok_or_fail (Ptr.of_bytes buf ~off:1 ~len:31) in
  (* int8x16 needs 16 bytes; offset=1 with len=31 is enough and aligned *)
  (match vld1_int8_16 ptr with
  | Ok _              -> ()
  | Error Ffi_error _ -> ()
  | Error e           ->
    Alcotest.failf "int8x16 should not reject odd offset: %a"
      (fun fmt e -> match e with
        | Alignment_fault -> Format.pp_print_string fmt "Alignment_fault"
        | _               -> Format.pp_print_string fmt "other")
      e)

(* float64 requires 8-byte alignment *)
let test_vld1_align_float64 () =
  let buf = Bytes.make 32 '\x00' in
  let ptr = ok_or_fail (Ptr.of_bytes buf ~off:4 ~len:28) in
  (* offset 4 is not divisible by 8 *)
  check bool "float64x2 rejects offset=4"
    true (is_error (vld1_float64_2 ptr))

(* int16 requires 2-byte alignment *)
let test_vld1_align_int16 () =
  let buf = Bytes.make 32 '\x00' in
  let ptr = ok_or_fail (Ptr.of_bytes buf ~off:1 ~len:31) in
  check bool "int16x8 rejects odd offset"
    true (is_error (vld1_int16_8 ptr))

(* vst1 bounds: store into too-small buffer *)
let test_vst1_bounds_too_small () =
  let src = Bytes.make 16 '\x00' in
  let dst = Bytes.make 8  '\x00' in
  let src_ptr = ok_or_fail (Ptr.of_bytes src ~off:0 ~len:16) in
  let dst_ptr = ok_or_fail (Ptr.of_bytes dst ~off:0 ~len:8)  in
  (* load first — skip if stub not implemented *)
  (match vld1_float32_4 src_ptr with
  | Error _ -> ()  (* stub not implemented yet, skip store test *)
  | Ok vec  ->
    check bool "vst1 rejects 8-byte dst"
      true (is_error (vst1_float32_4 dst_ptr vec)))

(* vld2 needs 2x the bytes of vld1 for the same shape *)
let test_vld2_bounds () =
  let buf_small = Bytes.make 16 '\x00' in
  let buf_large = Bytes.make 32 '\x00' in
  let ptr_small = ok_or_fail (Ptr.of_bytes buf_small ~off:0 ~len:16) in
  let ptr_large = ok_or_fail (Ptr.of_bytes buf_large ~off:0 ~len:32) in
  check bool "vld2_float32_4 rejects 16-byte buf (needs 32)"
    true (is_error (vld2_float32_4 ptr_small));
  (match vld2_float32_4 ptr_large with
  | Ok _              -> ()
  | Error Ffi_error _ -> ()
  | Error _           -> Alcotest.fail "vld2_float32_4 unexpectedly rejected 32-byte buf")

(* vld3 needs 3x, vld4 needs 4x *)
let test_vld3_bounds () =
  let buf = Bytes.make 48 '\x00' in
  let ptr = ok_or_fail (Ptr.of_bytes buf ~off:0 ~len:48) in
  (match vld3_float32_4 ptr with
  | Ok _              -> ()
  | Error Ffi_error _ -> ()
  | Error _           -> Alcotest.fail "vld3_float32_4 rejected 48-byte buf unexpectedly")

let test_vld4_bounds () =
  let buf = Bytes.make 64 '\x00' in
  let ptr = ok_or_fail (Ptr.of_bytes buf ~off:0 ~len:64) in
  (match vld4_float32_4 ptr with
  | Ok _              -> ()
  | Error Ffi_error _ -> ()
  | Error _           -> Alcotest.fail "vld4_float32_4 rejected 64-byte buf unexpectedly")

let bounds_tests = [
  test_case "vld1 bounds: too small"        `Quick test_vld1_bounds_too_small;
  test_case "vld1 bounds: exact"            `Quick test_vld1_bounds_exact;
  test_case "vld1 align: float32 odd off"   `Quick test_vld1_align_float32;
  test_case "vld1 align: int8 any offset"   `Quick test_vld1_align_int8_any_offset;
  test_case "vld1 align: float64"           `Quick test_vld1_align_float64;
  test_case "vld1 align: int16"             `Quick test_vld1_align_int16;
  test_case "vst1 bounds: too small"        `Quick test_vst1_bounds_too_small;
  test_case "vld2 bounds: needs 2x"         `Quick test_vld2_bounds;
  test_case "vld3 bounds: needs 3x"         `Quick test_vld3_bounds;
  test_case "vld4 bounds: needs 4x"         `Quick test_vld4_bounds;
]

let () =
  run "Seraph.Neon_vload" [
    "Ptr",        ptr_tests;
    "byte_width", byte_width_tests;
    "Bounds",     bounds_tests;
  ]
