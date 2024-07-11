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
Line 3, characters 4-7:
3 |   f str
        ^^^
Error: This value escapes its region.
  Hint: This argument cannot be local,
  because it is an argument in a tail call.
|}]
