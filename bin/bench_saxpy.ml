open Bigarray

module B = Seraph.Bindings
module S = Seraph.Scalar

type fn = float -> B.f32arr -> B.f32arr -> int -> unit

let variant_fn : string -> fn = function
  | "scalar" -> fun a x y _n -> S.saxpy a x y
  | "neon" -> B.saxpy_neon
  | "optim" -> B.saxpy_optim
  | "clang" -> B.saxpy_gen
  | "clang_restrict" -> B.saxpy_restrict_gen
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
  let alpha = 2.5 in
  let x = make_random n in
  let y = make_random n in
  (* Touch the result so the optimizer/loop can't be a complete no-op
     and so we get a stable steady-state working set, matching what
     Alcotest's warmup ~iters:5 was doing before. *)
  for _ = 1 to 5 do
    f alpha x y n
  done;
  for _ = 1 to reps do
    f alpha x y n
  done
