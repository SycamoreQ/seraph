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
  let expected = Seraph.Scalar.sum_reduce x in
  let actual = B.sum_reduce_neon x n in
  Alcotest.(check (float 1e-3)) (Printf.sprintf "sum_reduction n=%d" n) expected actual

let sum_reduction_tests =
  List.map
    (fun n -> Alcotest.test_case (Printf.sprintf "n=%d" n) `Quick (test_length n))
    lengths

(* sum_reduce_optim correctness — this is the kernel that had the
   off-by-32 remainder bug (pre-loop check subtracted 16 but the loop
   body consumes 32 elements/iter, so the post-loop fixup added back
   the wrong amount and read 16 floats past the buffer whenever n was
   large enough to enter the unrolled loop at all, i.e. n >= 32).
   These lengths deliberately straddle every tier boundary:
     - 31/32/33   : edge of the 32-wide unrolled loop (this is where
                    the bug lived — n=32 exactly enters the loop once)
     - 35/36      : edge of the 4-wide single-vector loop
     - 63/64/65   : two full unrolled iterations boundary
     - 1000003    : large, not a clean multiple of 32, exercises all
                    three tiers (unrolled + single-vector + scalar tail)
                    in one call *)
let optim_lengths = lengths @ [ 35; 36; 63; 64; 65; 1000003 ]

let test_optim_length n () =
  let x = make_random n in
  let expected = Seraph.Scalar.sum_reduce x in
  let actual = B.sum_reduce_optim x n in
  (* Tolerance scales with n: summing more float32 terms accumulates
     more rounding-order noise between a linear scalar sum and a
     tree-reduced NEON sum, even when both are "correct." *)
  let tol = 1e-3 *. (1.0 +. (Float.of_int n *. 1e-6) *. Float.abs expected) in
  Alcotest.(check (float tol)) (Printf.sprintf "sum_reduce_optim n=%d" n) expected actual

let sum_reduce_optim_tests =
  List.map
    (fun n -> Alcotest.test_case (Printf.sprintf "n=%d" n) `Quick (test_optim_length n))
    optim_lengths

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

type sum_reduction_fn = B.f32arr -> int -> float

let sum_reduce_variants : (string * sum_reduction_fn) list =
  [
    ("scalar (OCaml)", fun x _n -> Seraph.Scalar.sum_reduce x);
    ("neon (handwritten, baseline)", B.sum_reduce_neon);
    ("neon  (handwritten, optimized)", B.sum_reduce_optim);
    ("clang -O3, no restrict", B.sum_reduce_gen);
    ("clang -O3, restrict", B.sum_reduce_restrict_gen);
  ]

let bench_size (regime, n, reps) () =
  Printf.printf "\n-- %s (n=%d, reps=%d) --\n%!" regime n reps;
  let x = make_random n in
  List.iter
    (fun (name, f) ->
      warmup ~iters:5 (fun () -> ignore (f x n));
      let t = time_block ~reps (fun () -> ignore (f x n)) in
      let flops = float_of_int (n - 1) in
      let bytes = 4.0 *. float_of_int n in
      Printf.printf "  %-28s %10.2f ns/call  %8.2f GFLOP/s  %8.2f GB/s\n%!"
        name (t *. 1e9)
        (flops /. t /. 1e9)
        (bytes /. t /. 1e9))
    sum_reduce_variants

let saxpy_bench_tests =
  List.map
    (fun ((regime, _, _) as size) -> Alcotest.test_case regime `Quick (bench_size size))
    bench_sizes

let () =
  Random.self_init ();
  Alcotest.run
    ~argv:(Array.append Sys.argv [| "-v" |])
    "seraph"
    [ ("sum reduction", sum_reduction_tests);
      ("sum-reduction-optim", sum_reduce_optim_tests);
      ("sum-reduction-bench", saxpy_bench_tests)
    ]
