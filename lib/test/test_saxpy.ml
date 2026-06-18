open Bigarray
module B = Seraph.Bindings

let make_random n : B.f32arr =
  let a = Array1.create float32 c_layout n in
  for i = 0 to n - 1 do
    a.{i} <- Random.float 10.0 -. 5.0
  done;
  a

let to_array (a : B.f32arr) = Array.init (Array1.dim a) (fun i -> a.{i})

let test_length n () =
  let a = 2.5 in
  let x = make_random n in
  let y_ref = make_random n in
  let y_neon : B.f32arr = Array1.create float32 c_layout n in
  Array1.blit y_ref y_neon;
  Seraph.Scalar.saxpy a x y_ref;
  B.saxpy_neon a x y_neon n;
  Alcotest.(check (array (float 1e-4)))
    (Printf.sprintf "saxpy n=%d" n)
    (to_array y_ref) (to_array y_neon)

let lengths = [ 1; 2; 3; 4; 5; 7; 8; 9; 16; 17; 31; 32; 33; 100; 1000 ]

let saxpy_tests =
  List.map
    (fun n ->
      Alcotest.test_case (Printf.sprintf "n=%d" n) `Quick (test_length n))
    lengths

let () = Alcotest.run "seraph" [ ("saxpy", saxpy_tests) ]
