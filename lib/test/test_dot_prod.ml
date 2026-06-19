open Bigarray
module B = Seraph.Bindings

let make_random n : B.f32arr =
  let a = Array1.create float32 c_layout n in
  for i = 0 to n - 1 do
    a.{i} <- Random.float 10.0 -. 5.0
  done;
  a


let lengths = [ 1; 2; 3; 4; 5; 7; 8; 9; 16; 17; 31; 32; 33; 100; 1000 ]

let test_length n () =
  let x = make_random n in
  let y = make_random n in
  let expected = Seraph.Scalar.dot_prod x y in
  let actual = B.dot_neon x y n in
  Alcotest.(check (float 1e-3)) (Printf.sprintf "dot n=%d" n) expected actual

let dot_tests =
  List.map
    (fun n -> Alcotest.test_case (Printf.sprintf "n=%d" n) `Quick (test_length n))
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

type dot_fn = B.f32arr -> B.f32arr -> int -> float

let dot_variants : (string * dot_fn) list =
  [
    ("scalar (OCaml)", fun x y _n -> Seraph.Scalar.dot_prod x y);
    ("neon (hand-written, 1 acc)", B.dot_neon);
    ("clang -O3, no restrict", B.dot_prod_gen);
    ("clang -O3, restrict", B.dot_prod_restrict_gen);
  ]

let bench_size (regime, n, reps) () =
  Printf.printf "\n-- %s (n=%d, reps=%d) --\n%!" regime n reps;
  let x = make_random n in
  let y = make_random n in
  List.iter
    (fun (name, f) ->
      (* checksum is cheap insurance against the call being optimized
         away, and doubles as a sanity signal -- "nan" here means
         something's broken regardless of timing *)
      let checksum = ref 0.0 in
      warmup ~iters:5 (fun () -> checksum := !checksum +. f x y n);
      let t = time_block ~reps (fun () -> checksum := !checksum +. f x y n) in
      let flops = 2.0 *. float_of_int n in
      let bytes = 8.0 *. float_of_int n in
      (* read x, read y, no writes *)
      Printf.printf "  %-28s %10.2f ns/call  %8.2f GFLOP/s  %8.2f GB/s  (checksum=%.3g)\n%!"
        name (t *. 1e9)
        (flops /. t /. 1e9)
        (bytes /. t /. 1e9)
        !checksum)
    dot_variants

let dot_bench_tests =
  List.map
    (fun ((regime, _, _) as size) -> Alcotest.test_case regime `Quick (bench_size size))
    bench_sizes

let () =
  Random.self_init ();
  Alcotest.run
    ~argv:(Array.append Sys.argv [| "-v" |])
    "seraph"
    [ ("dot", dot_tests); ("dot-bench", dot_bench_tests) ]
