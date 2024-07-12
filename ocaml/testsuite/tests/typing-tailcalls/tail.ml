(* TEST
 flags = "-dtypedtree -dsel";
 native;
*)

(* These calls should be inferred as tail-calls because they call a function
   defined locally via a let rec in tail position. *)
let rec foo n =
  if n > 0 then foo (n - 2) else ()

let rec bar n =
  if n > 0 then baz (n - 2) else ()
and [@inline never] baz n = bar (n + 1)

