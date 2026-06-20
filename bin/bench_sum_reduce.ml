open Bigarray

module B = Seraph.Bindings
module S = Seraph.Scalar

type fn = B.f32arr -> int -> float

let variant_fn : string -> fn = function
  | "scalar" -> fun x _n -> S.sum_reduce x
  | "neon" -> B.sum_reduce_neon
  | "optim" -> B.sum_reduce_optim
  | "clang" -> B.sum_reduce_gen
  | "clang_restrict" -> B.sum_reduce_restrict_gen
  | other ->
    Printf.eprintf
      "unknown variant %S (expected: scalar | neon | optim | clang | clang_restrict)\n"
      other;
    exit 1

let make_random n : B.f32arr =
  let a = Array1.create float32 c_layout n in
  for i = 0 to n - 1 do
    a.{i} <- Random.float 10.0 -. 5.0
  done;
  a

let () =
  if Array.length Sys.argv < 3 then begin
    Printf.eprintf "usage: %s <variant> <n> [reps]\n" Sys.argv.(0);
    exit 1
  end;
  let variant = Sys.argv.(1) in
  let n = int_of_string Sys.argv.(2) in
  let reps = if Array.length Sys.argv >= 4 then int_of_string Sys.argv.(3) else 100_000 in
  let f = variant_fn variant in
  Random.self_init ();
  let x = make_random n in
  let acc = ref 0.0 in
  for _ = 1 to 5 do
    acc := !acc +. f x n
  done;
  for _ = 1 to reps do
    acc := !acc +. f x n
  done;
  if !acc = Float.nan then print_float !acc
