(* Plain scalar reference: the ground truth every hand-written kernel
   gets checked against. *)

val saxpy : float -> Bindings.f32arr -> Bindings.f32arr -> unit

val dot_prod : Bindings.f32arr -> Bindings.f32arr -> float
