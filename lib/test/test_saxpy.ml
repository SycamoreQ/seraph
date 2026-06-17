open Bigarray

let make_random n : Saxpy_lib.Kernels.f32arr =
  let a = Array1.create float32 c_layout n in
  for i = 0 to n - 1 do
    a.{i} <- Random.float 10.0 -. 5.0
  done;
  a

let test_one n =
  let a = 2.5 in
  let x = make_random n in
  let y_ref = make_random n in
  let y_neon : Saxpy_lib.Kernels.f32arr = Array1.create float32 c_layout n in
  Array1.blit y_ref y_neon;
  Saxpy_lib.Scalar.saxpy a x y_ref;
  Saxpy_lib.Kernels.saxpy_neon a x y_neon n;
  let max_err = ref 0.0 in
  for i = 0 to n - 1 do
    let d = Float.abs (y_ref.{i} -. y_neon.{i}) in
    if d > !max_err then max_err := d
  done;
  Printf.printf "n=%-5d max_err=%-12g %s\n%!" n !max_err
    (if !max_err < 1e-4 then "OK" else "FAIL")

let () =
  Random.self_init ();
  (* Deliberately include lengths that aren't multiples of 4, to exercise
     the tail loop -- exactly the place hand-vectorized kernels tend to
     break. *)
  List.iter test_one [ 1; 2; 3; 4; 5; 7; 8; 9; 16; 17; 31; 32; 33; 100; 1000 ]
