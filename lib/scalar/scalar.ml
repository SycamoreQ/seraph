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


let softmax (x : Bindings.f32arr) =
  let n = Array1.dim x in
  let max_x = Array.fold_left Float.max neg_infinity
                (Array.init n (fun i -> x.{i})) in
  let sum = ref 0.0 in
  for i = 0 to n - 1 do
    let v = exp (x.{i} -. max_x) in
    x.{i} <- v;
    sum := !sum +. v
  done;
  for i = 0 to n - 1 do
    x.{i} <- x.{i} /. !sum
  done
