open Bigarray

module B = Seraph.Bindings


let make_random n : B.f32arr =
  let a = Array1.create float32 c_layout n in
  for i = 0 to n - 1 do
    a.{i} <- Random.float 10.0 -. 5.0
  done;
  a

let test_length n () =
  let x = make_random n in
  let y = make_random n in
  let expected = Seraph.Scalar.dot_prod x y in
  let actual = B.dot_neon x y n in
  Alcotest.(check (float 1e-3)) (Printf.sprintf "dot n=%d" n) expected actual

let lengths = [ 1; 2; 3; 4; 5; 7; 8; 9; 16; 17; 31; 32; 33; 100; 1000 ]

let dot_tests =
  List.map
    (fun n ->
      Alcotest.test_case (Printf.sprintf "n=%d" n) `Quick (test_length n))
    lengths

let () = Alcotest.run "seraph" [ ("dot", dot_tests) ]
