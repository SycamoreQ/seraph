open Bigarray
module B = Seraph.Bindings

let make_random n : B.f32arr =
  let a = Array1.create float32 c_layout n in
  for i = 0 to n - 1 do
    a.{i} <- Random.float 1.0 -. 0.5
  done;
  a

let to_array (a : B.f32arr) = Array.init (Array1.dim a) (fun i -> a.{i})


let lengths = [ 1; 2; 3; 4; 5; 7; 8; 9; 16; 17; 31; 32; 33; 100; 1000 ]

let test_length n () =
  let input = make_random n in
  let y_ref  : B.f32arr = Array1.create float32 c_layout n in
  let y_neon : B.f32arr = Array1.create float32 c_layout n in
  Array1.blit input y_ref;
  Array1.blit input y_neon;
  Seraph.Scalar.softmax y_ref;
  B.softmax_neon y_neon n;
  (* Tolerance is 1e-2, not 1e-4 as with SAXPY: the 4-term Horner
     approximation only gives ~2-3 decimal digits of accuracy in exp,
     so larger element-wise error is expected and correct. *)
  Alcotest.(check (array (float 1e-2)))
    (Printf.sprintf "softmax values n=%d" n)
    (to_array y_ref) (to_array y_neon);
  (* Sanity check: a valid softmax output must sum to 1.0 regardless
     of the approximation used -- this catches a whole class of bugs
     (wrong reciprocal, missing normalization pass) that the element-
     wise comparison might not surface clearly on its own. *)
  let sum = Array.fold_left ( +. ) 0.0 (to_array y_neon) in
  Alcotest.(check (float 1e-4))
    (Printf.sprintf "softmax sum=1 n=%d" n) 1.0 sum

let softmax_tests =
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

type softmax_fn = B.f32arr -> int -> unit

let softmax_variants : (string * softmax_fn) list =
  [
    ("scalar (OCaml)", fun x _n -> Seraph.Scalar.softmax x);
    ("neon (hand-written)", B.softmax_neon);
    ("clang -O3, no restrict", B.softmax_gen);
    ("clang -O3, restrict", B.softmax_restrict_gen);
  ]

let bench_size (regime, n, reps) () =
  Printf.printf "\n-- %s (n=%d, reps=%d) --\n%!" regime n reps;
  List.iter
    (fun (name, f) ->
      let buf = make_random n in
      warmup ~iters:5 (fun () -> f buf n);
      let t = time_block ~reps (fun () -> f buf n) in
      let flops = 8.0 *. float_of_int n in
      let bytes  = 8.0 *. float_of_int n *. 4.0 in
      Printf.printf "  %-28s %10.2f ns/call  %8.2f GFLOP/s  %8.2f GB/s\n%!"
        name (t *. 1e9)
        (flops /. t /. 1e9)
        (bytes /. t /. 1e9))
    softmax_variants

let softmax_bench_tests =
  List.map
    (fun ((regime, _, _) as size) -> Alcotest.test_case regime `Quick (bench_size size))
    bench_sizes

let () =
  Random.self_init ();
  Alcotest.run
    ~argv:(Array.append Sys.argv [| "-v" |])
    "seraph"
    [ ("softmax", softmax_tests); ("softmax-bench", softmax_bench_tests) ]
