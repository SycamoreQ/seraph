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


let time_block ~reps (f : unit -> unit) : float =
  let t0 = Unix.gettimeofday () in
  for _ = 1 to reps do
    f ()
  done;
  let t1 = Unix.gettimeofday () in
  (t1 -. t0) /. float_of_int reps

let warmup ~iters (f : unit -> unit) =
  for _ = 1 to iters do
    f ()
  done

let bench_sizes = [ ("L1", 256, 200_000); ("L2", 65_536, 2_000); ("DRAM", 4_000_000, 30) ]

type saxpy_fn = float -> B.f32arr -> B.f32arr -> int -> unit

let saxpy_variants : (string * saxpy_fn) list =
  [
    ("scalar (OCaml)", fun a x y _n -> Seraph.Scalar.saxpy a x y);
    ("neon (hand-written)", B.saxpy_neon);
    ("clang -O3, no restrict", B.saxpy_gen);
    ("clang -O3, restrict", B.saxpy_restrict_gen);
  ]

let bench_size (regime, n, reps) () =
  Printf.printf "\n-- %s (n=%d, reps=%d) --\n%!" regime n reps;
  let x = make_random n in
  let y = make_random n in
  List.iter
    (fun (name, f) ->
      warmup ~iters:5 (fun () -> f 2.5 x y n);
      let t = time_block ~reps (fun () -> f 2.5 x y n) in
      let flops = 2.0 *. float_of_int n in
      let bytes = 12.0 *. float_of_int n in
      Printf.printf "  %-28s %10.2f ns/call  %8.2f GFLOP/s  %8.2f GB/s\n%!"
        name (t *. 1e9)
        (flops /. t /. 1e9)
        (bytes /. t /. 1e9))
    saxpy_variants

let saxpy_bench_tests =
  List.map
    (fun ((regime, _, _) as size) -> Alcotest.test_case regime `Quick (bench_size size))
    bench_sizes

let () =
  Random.self_init ();
  Alcotest.run
    ~argv:(Array.append Sys.argv [| "-v" |])
    "seraph"
    [ ("saxpy", saxpy_tests); ("saxpy-bench", saxpy_bench_tests) ]
