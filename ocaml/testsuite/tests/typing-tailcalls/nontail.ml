(* TEST
 flags = "-dtypedtree -dsel";
 native;
*)

let [@inline never] f str = print_endline str

module M = struct
  let f = f
end

(* These calls should not be inferred as tail-calls because the last application's
   function is not defined (locally) via a let rec. *)
let foo () =
  f "hello";
  f "goodbye"

let bar () =
  f "hello";
  M.f "goodbye"
  

