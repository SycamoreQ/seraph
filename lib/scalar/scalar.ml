open Bigarray

let saxpy (a : float) (x : Bindings.f32arr) (y : Bindings.f32arr) =
  let n = Array1.dim x in
  for i = 0 to n - 1 do
    y.{i} <- (a *. x.{i}) +. y.{i}
  done

let dot_prod (x: Bindings.f32arr) (y: Bindings.f32arr) =
  let n = Array1.dim x in
  let sum = ref 0.0 in
  for i = 0 to n-1 do
    sum := !sum +. (x.{i} *. y.{i})
  done;
  !sum


let sum_reduce(x: Bindings.f32arr) =
  let n = Array1.dim x in
  let sum = ref 0.0 in
  for i = 0 to n-1 do
    sum := !sum +. x.{i}
  done;
  !sum
