open Bigarray

(* Plain scalar reference: the ground truth every hand-written kernel
   gets checked against. *)
let saxpy (a : float) (x : Kernels.f32arr) (y : Kernels.f32arr) =
  let n = Array1.dim x in
  for i = 0 to n - 1 do
    y.{i} <- (a *. x.{i}) +. y.{i}
  done
