(* TEST
   expect;
*)

let [@inline never] f (local_ str) = let _ = str in ()

[%%expect {|
val f : local_ 'a -> unit = <fun>
|}]

module M = struct
  let f = f
end
[%%expect {|
module M : sig val f : local_ 'a -> unit end
|}]

let implicit_nontail () =
  let local_ str = "hello" in
  M.f str
[%%expect {|
val implicit_nontail : unit -> unit = <fun>
|}]

let explicit_nontail () =
  let local_ str = "hello" in
  M.f str [@nontail]
[%%expect {|
val explicit_nontail : unit -> unit = <fun>
|}]

let implicit_nontail_overriden_by_tail () =
  let local_ str = "hello" in
  M.f str [@tail]
[%%expect {|
Line 3, characters 6-9:
3 |   M.f str [@tail]
          ^^^
Error: This value escapes its region.
  Hint: This argument cannot be local,
  because it is an argument in a tail call.
|}]

let implicit_tail () =
  let local_ str = "hello" in
  f str
[%%expect {|
val implicit_tail : unit -> unit = <fun>
|}]


let rec implicit_tail n str =
  let local_ str = "hello" in
  if n > 0 then implicit_tail (n - 1) str else f str
[%%expect {|
Line 3, characters 38-41:
3 |   if n > 0 then implicit_tail (n - 1) str else f str
                                          ^^^
Error: This value escapes its region.
  Hint: This argument cannot be local,
  because it is an argument in a tail call.
|}]


(* Check that locals cannot be passed into mutually recursive tail calls. *)
let rec implicit_tail_foo n str =
  let local_ str = "hello" in
  if n > 0 then implicit_tail_bar (n - 2) str else f str
and implicit_tail_bar n str =
  implicit_tail_foo (n + 1) str
[%%expect {|
Line 3, characters 42-45:
3 |   if n > 0 then implicit_tail_bar (n - 2) str else f str
                                              ^^^
Error: This value escapes its region.
  Hint: This argument cannot be local,
  because it is an argument in a tail call.
|}]

