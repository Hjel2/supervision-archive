(** Foundations of Computer Science Supervision 1
 *  hjel2 Harry Langford
 *  1100 24th October 2021

    Fill in the various 'TODO' and 'failwith "TODO?"' items and submit
    your work to John Fawcett (jkf21@cam.ac.uk) by 5pm on the day before
    your supervision.

    The questions below contain some OCaml syntax that you are not
    expected to learn (and will not show up in the exam). The
        sig ... end = struct ... end
    blocks give the names and types of the top-level functions that you
    are asked to implement.

    Do _not_ use any helper modules in the standard library ([List], [Set],
    [Hashtbl] etc.). In particular, you should define [filter], [map] and
    [fold] etc. yourself. *)

module Type_inference = struct
  (** 1. Give the inferred types of each of the following functions: *)

  (** type: 'a -> 'b -> 'a *)
  let f a _b = a

  (** type: 'a -> 'b -> 'b *)
  let g _a b = b

  (** type: bool -> 'a -> 'a -> 'a *)
  let h a b c =
    if a then
      b
    else
      c

  (** type: ('a -> 'b) -> 'a -> 'b *)
  let i a b = a b

  (** type: ('a -> 'b -> 'c) -> ('a -> 'b) 'a -> 'c *)
  let j a b c = a c (b c)
end

module Type_driven_development : sig
  (** 2. For each of the following function types, either give a function of
      that type or argue informally why this cannot be done.

      N.B. you may not use any functions from the standard library ([failwith],
      [invalid_arg], etc.), assertions, exceptions or type annotations. *)

  val f : 'a -> unit

  val g : ('a -> 'b) -> 'a -> 'b

  val h : 'a list * 'b list -> ('a * 'b) list

  (*val i : 'a list -> 'b list*)
end = struct
  let f x = ();;

  let g x y = x y;;

  let rec h (x, y) =
    match (x, y) with
      | (xhd :: xtl, yhd :: ytl) -> (xhd, yhd) :: h (xtl, ytl)
      | (_, _) -> []
  ;;

  (* i is impossible as described.
  Without a function passed as a parameter, we cannot map 'a to 'b
  SO i - mapping 'a list -> 'b list is not possible
  However: if i was inside a wrapper function which was passed a function,
  it could be defined as
  let wrapper p a =
    let i a = p a
    in
    i a
  ;;
   *)

end

module Mystery_complexities = struct

  (** 3. For each of the following functions:

      - give a concise description of their behaviour
      - state their space and time complexities in terms of their
        non-functional parameters.

      Assume that the compiler performs no optimisations on the given code. *)

  (** description: The function f returns 1 if there is an element in the list l
  which satisfies the predicate pred. Else it returns 0.
  It is not tail recursive (although a good compiler could make it tail-recursive).

      {[
        +--------------+-------------------------+------------------------+
        | parameter, p | space complexity, s(p)  | time complexity, t(p)  |
        +--------------+-------------------------+------------------------+
        | l            | O(n)                    | O(n)                   |
        +--------------+-------------------------+------------------------+
      ]} *)
  let rec f pred l =
    match l with
    | [] -> 0
    | x :: xs ->
        if pred x then
          1
        else
          0 + f pred xs

  (** description: f' returns the number of elements in the list l which
  satisfy the predicate pred.
  It defines a function inner, which has an accumulator (and is tail recursive)
  and is called once per element in the list.

      {[
        +--------------+-------------------------+------------------------+
        | parameter, p | space complexity, s(p)  | time complexity, t(p)  |
        +--------------+-------------------------+------------------------+
        | l            | O(1)                    | O(n)                   |
        +--------------+-------------------------+------------------------+
      ]} *)
  let f' pred l =
    let rec inner l acc =
      match l with
      | [] -> acc
      | x :: xs ->
          let inc =
            if pred x then
              1
            else
              0
          in
          inner xs (acc + inc)
    in
    inner l 0

  (** description: g n calculates the nth fibonacci number. It calls
  itself on (n - 1) and (n - 2) until n <= 1; where it returns n.

      {[
        +--------------+-------------------------+------------------------+
        | parameter, p | space complexity, s(p)  | time complexity, t(p)  |
        +--------------+-------------------------+------------------------+
        | n            | O(n)                    | O(2 ^ n)               |
        +--------------+-------------------------+------------------------+
      ]} *)
  let rec g n =
    if n > 1 then
      g (n - 1) + g (n - 2)
    else
      n

  (** description: h calls id_map (an identity function) on progressively
  smaller sublists of the l. It returns a list containing sublists of l
  excluding the full list l. So [1;2;3] -> [[1; 2; 3]; [2; 3]; [3]]. h is not tail recursive.

      {[
        +--------------+-------------------------+------------------------+
        | parameter, p | space complexity, s(p)  | time complexity, t(p)  |
        +--------------+-------------------------+------------------------+
        | l            | O(n^2)                  | O(n^2)                 |
        +--------------+-------------------------+------------------------+
      ]} *)
  let rec h l =
    let rec id_map xs =
      match xs with
      | [] -> []
      | x :: xs -> x :: id_map xs
    in
    match l with
    | [] -> []
    | _ :: tl -> id_map l :: h tl
end

module Factors : sig
  (** 4. Write a function [factors] that converts a list of integers into a
      list of lists of the factors of those integers. For example,

      {[ factors [1; 4; 12] = [[1]; [1; 2; 4]; [1; 2; 3; 4; 6; 12]] ]}

      The order of the factors within each internal list is not important. *)
  val factors : int list -> int list list
end = struct
  let factors x =
    let rec factorlist k n =
      if k > n then []
      else if n mod k = 0
           then k :: factorlist (k + 1) n
           else factorlist (k + 1) n
    in
    let rec map = function
      | [] -> []
      | hd :: tl -> factorlist 1 hd :: map tl
    in
    map x
  ;;
end

module Sets : sig
  (** 1995 Paper 1 Question 3 *)

  (** 5. An OCaml list can be considered to be a set if it has no repeated
      elements, e.g., [4; 2; 3] is a set but [4; 2; 4; 3] is not.

      Write an OCaml function [intersect] to compute the set-theoretic
      intersection of two lists that satisfy this property of being a set. (The
      intersection of two sets is the set of elements that appear in both
      sets.) Your function must also satisfy conditions (a)--(c) below:

      (a) The result list has no repeated elements;

      (b) The number of cons (::) operations performed does not exceed the
      number of elements in the result list.

      (c) The elements of the result list appear in the same order as they do
      in the first argument list.

      You may assume the existence of [] (nil) and :: (cons). All other
      functions over lists must be defined by you. Little credit will be given
      for answers that do not satisfy conditions (a)--(c). *)
  val intersect : int list -> int list -> int list

  (** Write an OCaml function [subtract] that given two lists satisfying the
      property of being a set, returns a list consisting of those elements of
      the first list that do not appear in the second list. Your subtract
      function must satisfy conditions (a)--(c) above. *)
  val subtract : int list -> int list -> int list

  (** Write an OCaml function [union] that given two lists satisfying the
      property of being a set, returns a list consisting of those elements that
      appear in one or other or both of the lists. Your union function must
      satisfy conditions (a)--(c) above and (d) below:

      (d) Elements from the first argument list appear before any others in the
      result. *)
  val union : int list -> int list -> int list
end = struct

  (*I implicitly assumed that the :: constraint did not apply to pattern
  matching - if this is wrong then please say and I'll [struggle to] find a
  way to do it without *)

  let intersect a b =
    let rec member x = function
      | [] -> false
      | hd :: tl -> if x = hd then true
                    else member x tl
    in
    let rec asinb b = function
      | [] -> []
      | hd :: tl -> if member hd b
                    then hd :: asinb b tl
                    else asinb b tl
    in
    asinb b a
  ;;

  let subtract a b =
    let rec member x = function
      | [] -> false
      | hd :: tl -> if x = hd then true
                    else member x tl
    in
    let rec keepunique b = function
      | [] -> []
      | hd :: tl -> if member hd b
                    then keepunique b tl
                    else hd :: keepunique b tl
    in
    keepunique b a
  ;;

  let union a b =
    let rec member x = function
      | [] -> false
      | hd :: tl -> if x = hd then true
                    else member x tl
    in
    let rec getuniqueb a = function
      | [] -> []
      | hd :: tl -> if (member hd a)
                    then getuniqueb a tl
                    else hd :: (getuniqueb a tl)
    in
    let rec addtofront x y =
      match x with
        | [] -> y
        | hd :: tl -> hd :: addtofront tl y
    in
    addtofront a (getuniqueb a b)
    ;;
end
