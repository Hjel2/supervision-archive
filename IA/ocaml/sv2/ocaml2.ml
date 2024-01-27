(*---
title: Foundations of Computer Science SV#2
date + time of SV: <20:00 31 October 2021>
crsid: <hjel2>
---*)

module My_list : sig
  (** 1. Define the following utility functions on lists. Any use of recursion
      should be tail-recursive. State the space complexity of each function. *)

  (** (a) 'rev l' is the reversed form of 'l'. *)
  val rev : 'a list -> 'a list

  (** (b) 'map f l' is the list constructed by applying 'f' to each element of
      'l'. *)
  val map : ('a -> 'b) -> 'a list -> 'b list

  (** (c) 'filter p l' is the list containing all of the elements of 'l' that
      satisfy the predicate 'p'. The order of elements in the list is
      preserved. *)
  val filter : ('a -> bool) -> 'a list -> 'a list

  (** (d) 'fold_left f [b1; ... bn] a' is 'f (... (f (f a b1) b2) ...) bn'. *)
  (** Note that the arguments are presented in a different order from the
   *  similar function we saw in the introductory sessions.                 *)
  val fold_left : ('a -> 'b -> 'a) -> 'b list -> 'a -> 'a
end = struct

  (** space complexity: O(n) *)
  let rev l =
    let rec recrev acc = function
      | [] -> acc
      | hd :: tl -> recrev (hd :: acc) tl
    in
    recrev [] l
  ;;

  (** space complexity: O(n) *)
  let map f l =
    let rec recmap acc f = function
      | [] -> acc
      | hd :: tl -> recmap (f hd :: acc) f tl
    in
    let rec recrev acc = function
      | [] -> acc
      | hd :: tl -> recrev (hd :: acc) tl
    in
    recrev [] (recmap [] f l)
  ;;

  (** space complexity: O(n) *)
  let filter f l =
    let rec recfilter acc f = function
      | [] -> acc
      | hd :: tl -> if f hd then recfilter (hd :: acc) f tl else recfilter acc f tl
    in
    let rec recrev acc = function
      | [] -> acc
      | hd :: tl -> recrev (hd :: acc) tl
    in
    recrev [] (recfilter [] f l)
  ;;

  (** space complexity: O(n) *)
  let rec fold_left f b a =
    match b with
    | [] -> a
    | hd :: tl -> fold_left f tl (f a hd)
  ;;
end

module Partial_application : sig
  (** 2. Implement the following functions.

      For this question, you may use list utility functions in the 'List'
      module (see https://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html
      for details), or use your own definitions from above by writing e.g.
      'My_list.filter'. *)

  (** (a) 'increment_all l' creates a new list with each integer element
   *  being one greater than the corresponding item in the input list.      *)
  val increment_all : int list -> int list

  (** (b) sum totals the elements in a list. *)
  val sum : int list -> int

  (** (c) 'pairs_sum_to n l' takes an _ordered_ list 'l' and returns the list
      of all pairs (x, y) such that 'x' and 'y' are in 'l' and 'x + y = n'. *)
  val pairs_sum_to : int -> int list -> (int * int) list
end = struct
  let increment_all = List.map ((+) 1);;

  let sum = List.fold_left (+) 0;;

  let rec pairs_sum_to n =
    let rec tuplemap acc = function
      | [] -> acc
      | hd :: tl -> tuplemap ((hd, n - hd) :: (n - hd, hd) :: acc) tl
    in
    let rec pairsum n acc = function
      | [] -> acc
      | hd :: tl ->
        let nacc = tuplemap acc (List.filter ((=) (n - hd)) tl) in
        pairsum n nacc tl
    in
    pairsum n []
  ;;

  (* even more partially applied but to no actual gain
  let rec pairs_sum_to =
    let rec tuplemap n acc = function
      | [] -> acc
      | hd :: tl -> tuplemap n ((hd, n - hd) :: (n - hd, hd) :: acc) tl
    in
    let rec pairsum acc n = function
      | [] -> acc
      | hd :: tl ->
        let nacc = tuplemap n acc (List.filter ((=) (n - hd)) tl) in
        pairsum nacc n tl
    in
    pairsum []
  ;; *)

end

(** 3. Consider the following polymorphic tree data type: *)
type 'a tree = Branch of 'a * 'a tree list | Leaf

module List_tree : sig
  (** (a) Provide a function 'prune' that takes a predicate 'p' and a tree 't'
      and returns 't' with any subtrees (Branch (v,l)) such that 'p v = false'
      removed. *)
  val prune : ('a -> bool) -> 'a tree -> 'a tree

  (** (b) Provide a function 'count_subtrees' that takes a tree and replaces
      each value in the tree with a count of the number of Leaf nodes beneath
      that value in the tree. *)
  val count_subtrees : 'a tree -> int tree
end = struct
  let prune p t =
    let rec prune p t =
      match t with
      | Leaf -> t
      | Branch (v, l) ->
        let rec foreach p = function
          | [] -> []
          | hd :: tl -> (prune p hd) :: foreach p tl
        in
        if p v then Branch (v, foreach p l) else Leaf
    in
    prune p t
  ;;

  (* I wasn't quite sure whether prune should REMOVE branches or replace them
  with Leaf nodes. So I did both. The one above replaces them with Leaf nodes,
  the implementation in comments removes them completely (and returns a Leaf
  node if the whole tree is invalid) *)
  (*
  let prune p t =
        let rec prune p t =
           match t with
           | Leaf -> [t]
           | Branch (v, l) ->
                     let rec foreach p = function
                         | [] -> []
                         | hd :: tl -> (prune p hd) @ foreach p tl
                     in
                     if p v then [Branch (v, foreach p l)] else []
        in
        match prune p t with
        | [] -> Leaf
        | [Leaf] -> Leaf
        | [(Branch (v, t)) as b] -> b
        | _ -> assert false
  ;;
  *)

  let rec count_subtrees = function
    | Leaf -> Leaf
    | Branch (_, t) ->
      let rec recurse = function
        | [] -> []
        | hd :: tl -> (count_subtrees hd) :: recurse tl
      in
      let rec countleaves acc = function
        | [] -> acc
        | Leaf :: tl -> countleaves (acc + 1) tl
        | Branch (v, _) :: tl -> countleaves (acc + v) tl
      in
      let tl = recurse t in
      Branch (countleaves 0 tl, tl)
  ;;
end

(** 4. Provide a polymorphic datatype 'bin_tree' in which the leaves are empty
    and the branches contain arbitrary data (of type 'a) and have exactly two
    subtrees. *)
type 'a bin_tree = Leaf | Branch of 'a * 'a bin_tree * 'a bin_tree

(** For the following, we need to define a 'comparator'.
 *  An 'a comparator is a function 'c' that defines an ordering on values of
    type 'a such that:

    - 'c x y = -1' when 'x < y'
    - 'c x y = 0' when 'x = y'
    - 'c x y = 1' when 'x > y' *)
type 'a comparator = 'a -> 'a -> int

module Binary_search_tree : sig
  (** An 'a binary search tree is an 'a bin_tree 't' and an 'a comparator 'c'
      such that for each branch 'Branch (v, l, r)' in the tree:

      - all values in 'l' are _less than_ v as defined by 'c'
      - all values in 'r' are _greater than_ v as defined by 'c'

      The tree contains no duplicate elements. Define the following functions
      on binary search trees: *)

  (** (a) 'insert' takes a binary search tree 't' that is ordered according to
      a comparator 'c' and returns a function that inserts elements into that
      tree. *)
  val insert : 'a comparator -> 'a bin_tree -> 'a -> 'a bin_tree

  (** (b) 'fold f acc t' walks the binary tree 't' and returns accumulates the
      elements into the accumulator 'acc' using the function 'f', just as with
      the fold functions on lists. The order in which elements are accumulated
      does not matter. *)
  val fold : ('a -> 'b -> 'a) -> 'a -> 'b bin_tree -> 'a

  (** (c) a 'map' function on binary trees takes three parameters:

      - a function 'f' of type ('a -> 'a)
      - a comparator 'c' over values of type 'a
      - a binary tree 't' with values of type 'a, which is well-ordered with
        respect to 'c'

      and returns a binary search tree containing the values 'f v' for each 'v'
      in 't'. Provide two implementations of 'map': *)

  (** (i). 'map_monotonic', which assumes that 'f' is order-preserving with
      respect to comparator 'c'. That is: 'c x y' = 'c (f(x)) (f(y))' for all
      terms 'x' and 'y' of type 'a. *)
  val map_monotonic : ('a -> 'a) -> 'a comparator -> 'a bin_tree -> 'a bin_tree

  (** (ii). 'map_nonmonotonic', which does not make this assumption. *)
  val map_nonmonotonic :
    ('a -> 'a) -> 'a comparator -> 'a bin_tree -> 'a bin_tree
end = struct
  let rec insert c t x =
    match t with
    | Leaf -> Branch (x, Leaf, Leaf)
    | Branch (v, l, r) ->
      if c x v = 1
      then Branch (v, l, insert c r x)
      else Branch (v, insert c l x, r)
  ;;

  let rec fold f acc = function
    | Leaf -> acc
    | Branch (v, l, r) -> fold f (fold f (f acc v) l) r
  ;;

  let rec map_monotonic f c = function
    | Leaf -> Leaf
    | Branch (v, l, r) -> Branch (f v, map_monotonic f c l, map_monotonic f c r)
  ;;

  let map_nonmonotonic f c t =
    let rec getvalues acc = function
      | Leaf -> acc
      | Branch (v, l, r) -> (getvalues (v :: (getvalues acc r)) l)
    in
    let rec repeatinsert f c nt = function
      | [] -> nt
      | hd :: tl -> repeatinsert f c (insert c nt (f hd)) tl
    in
    repeatinsert f c Leaf (getvalues [] t)
  ;;
end

(* -------------------------------------------------------------------------- *)
(* EXTENSION QUESTIONS                                                        *)
(* -------------------------------------------------------------------------- *)

module MoreLists : sig
  (** 6. 'fold' functions are functions for 'summarising' data structures.
      'fold_right' is identical to 'fold_left', but consumes elements of the
      list from _right to left_. That is:

      {[
        fold_right f [a1; a2; ... an] b
        = f a1 (f a2 (... (f an b) ...))
      ]}

      a) implement 'fold_right'. Either give a tail-recursive implementation or
      argue why such an implementation cannot exist. Give the complexity of
      your implementation. *)
  val fold_right : ('a -> 'b -> 'b) -> 'b -> 'a list -> 'b

  (** b) Implement all of the list utility functions in terms of a _single_
      call to 'fold_right'. Your functions should _not_ be recursive or define
      any inner recursive functions. *)

  val length : 'a list -> int

  val map : ('a -> 'b) -> 'a list -> 'b list

  val filter : ('a -> bool) -> 'a list -> 'a list

  val append : 'a list -> 'a list -> 'a list

  val flatten : 'a list list -> 'a list

  val fold_left : ('a -> 'b -> 'a) -> 'b list -> 'a -> 'a
end = struct
  (** space complexity: O(n) *)
  let fold_right f acc l =
    let rec rfold f l r acc =
      match l with
        | hd :: tl -> rfold f tl (hd :: r) acc
        | [] ->
          match r with
            | [] -> acc
            | hd :: tl -> rfold f l tl (f hd acc)
    in
    rfold f l [] acc
  ;;

  let length l =
    let f = (fun x y -> y + 1) in
    let z = 0 in
    fold_right f z l
  ;;

  let map f =
    let f = (fun x y -> f x :: y) in
    let z = [] in
    fold_right f z
  ;;

  let filter f =
    let f = (fun x y -> if f x then x :: y else y) in
    let z = [] in
    fold_right f z
  ;;

  let append l2 l1 =
    let f = (fun x y -> x :: y) in
    fold_right f l1 l2
  ;;

  let flatten l =
    let f = append in
    let z = [] in
    fold_right f z l
  ;;

  (* N.B. this one is very hard... *)
  (* It feels like there is a different way of doing this *)
  let fold_left f li acc =
    let f = (fun x acc -> f acc x) in
    let z = List.rev li in
    fold_right f acc z
  ;;
end
[@warning "-20"] [@warning "-39"]
