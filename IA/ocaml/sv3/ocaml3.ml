(*---
title: Foundations of Computer Science SV#3
date + time of SV: <21:00 6 November 2021>
crsid: <hjel2>
---*)

module SetOperations : sig
  (** 1. A (mathematical) set is a duplicate free collection.  We can represent
   *  sets as lists, being careful not to include the same element twice in any
   *  list.  Define the following functions using this representation of sets. *)

  (** (a) 'ps s' is the powerset of 's': the set of all possible subsets of s,
   * including the empty set. *)
  val ps : 'a list -> 'a list list

  (** (b) 'isInjection f s1 s2' returns true if f is an injective function from
   * s1 to s2.  See https://en.wikipedia.org/wiki/Injective_function *)
  val isInjection : ('a -> 'b) -> 'a list -> 'b list -> bool

  (** (c) 'isSurjection f s1 s2' returns true if f is a surjective function from
   * s1 to s2.  See https://en.wikipedia.org/wiki/Surjective_function *)
  val isSurjection : ('a -> 'b) -> 'a list -> 'b list -> bool

  (** (d) 'isBijection f s1 s2' returns true if f is a bijective function from
   * s1 to s2.  See https://en.wikipedia.org/wiki/Bijective_function *)
  val isBijection : ('a -> 'b) -> 'a list -> 'b list -> bool
end = struct

  let ps s =
    List.fold_left (fun acc hd -> List.fold_left
      (fun ac x -> (hd :: x) :: ac) acc acc) [[]] s
  ;;

  let isInjection f s1 s2 =
    try let _ = List.fold_left
      (fun acc x -> let fx = f x in if List.exists ((=) fx) s2 && not
      (List.exists ((=) fx) acc) then fx::acc else raise Not_found) [] s1
    in true
    with Not_found -> false
  ;;

  let isSurjection f s1 s2 =
    try List.length s2 = List.length (List.fold_left (fun acc x ->
      let fx = f x in
      if List.exists ((=) fx) s2
      then (if List.exists ((=) fx) acc then acc else fx::acc)
      else raise Not_found) [] s1)
    with Not_found -> false
  ;;

  let isBijection f s1 s2 =
    isSurjection f s1 s2 && isInjection f s1 s2
  ;;
end

(** 2.
 * The datatype 'pri' defined below is to be used for the representation of
 * priority queues which are finite or infinite ordered sets of integers.
 *)
type pri = E | N of int*(unit->pri)

module PriorityQueues : sig
  (* Define an function that will return a representation of the ordered
   * set of integers { i, i+1, ..., j }. *)
   val intfromto : (int*int)->pri

  (* Define a function that will return the first (and hence smallest)
   * integer in a given queue p. *)
   val first : pri->int

  (* Define a function that will return (if possible) a representation of a
   * given queue p with its smallest element removed. Your implementation
   * should be such that the expression first(rest (intsfromto(20, 1000000)))
   * evaluates efficiently. *)
   val rest : pri->pri

  (* Define an function that will return a priority queue with the integer i
   * inserted in the proper position of a given queue p. *)
  val ins : (int*pri)->pri

end = struct
  let rec intfromto (n, k) =
    if n = k then N (n, fun () -> E)
    else N (n, fun () -> intfromto (n + 1, k))
  ;;

  let first = function
    | E -> raise (Failure "Empty priority queue")
    | N (n, _) -> n
  ;;

  let rest = function
    | E -> raise (Failure "Empty priority queue")
    | N (_, k) -> k()
  ;;

  let rec ins = function
    | (i, E) -> N(i, fun () -> E)
    | (i, N(k, f)) when i > k -> N(k, fun () -> ins (i, f ()))
    | (i, p) -> N (i, fun () -> p)
  ;;
end

(** Answer this past exam question on time complexities:
 *  https://www.cl.cam.ac.uk/teaching/exams/pastpapers/y1993p1q7.pdf          *)
(** State carefully what it means to say that a function has time complexity
 *  O(f(n)), and give ML definitions for some example int -> int functions
 *  which have time complexities O(log n), O(n), O(n^2), O(n^3). In what
 *  circumstances can a function have time complexity O(1)?                   *)

(** O(f(n)) means that the time taken for the algorithm to execute grows
 *  proportionally to f(n) where n is the size of an input variable.          *)

 (* Functions have been implemented in OCaml rather than ML *)

module Complexities = struct
 (* O(log n) function: finds floor(log n) *)
 let rec olgn = function
   | 1 -> 0
   | n -> 1 + olgn (n / 2)
 ;;

 (* O(n) function: finds an nth approximation to pi: *)
 let on n =
  let rec pi term acc = function
    | n when n <= 1 -> acc
    | n ->
      let next = sqrt((1. +. term)/. 2.) in
      pi next (acc /. next) (n - 1)
  in
  pi 0. 2. n
 ;;

 (* O(n^2) function: finds the number of primes less than or equal to n *)
 let rec on2 n =
  let rec isprime n = function
    | 1 -> 1
    | i when n mod i = 0 -> 0
    | i -> isprime n (i - 1)
  in
  match n with
    | 1 -> 0
    | i -> (isprime i (i - 1)) + on2 (i - 1)
 ;;

 (** O(n^3) function: finds the number less than or equal to n with the largest
  *  number of distinct prime factors. If multiple numbers have the same number
  *  of prime factors then it returns the largest of these                    *)

 let on3 n =
    let rec isprime n = function
      | 1 -> true
      | i -> not (n mod i = 0) && isprime n (i - 1)
    in
    let rec findprimefactors n = function
      | 1 -> 0
      | i when isprime i (i - 1) && n mod i = 0 -> 1 + findprimefactors n (i -1)
      | i -> findprimefactors n (i - 1)
    in
    let rec maxprimefactors = function
      | 1 -> (1, 0)
      | n -> let y = findprimefactors n (n - 1) in
             match maxprimefactors (n - 1) with
              | (a, x) when x > y-> (a, x)
              | _ -> (n, y)
    in
    let (x, _) = maxprimefactors n in
    x
  ;;
end
 (* Estimate the time complexities of the functions f1, f2 and f3 defined below:

  fun f1 0 = 1
   | f1 n = 1 + f1 (n - 1)
  ;;
  f1 is O(n)
  By inspection.

  fun f2 0 = 1
   | f2 n = f2 (n - 1) + f1 n
  ;;
  f2 is O(n^2)
  Intuitively obvious. n calls to an O(n) function.

  fun f3 0 = 1
   | f3 n = f3 (n div 7) + f3 (5 * n div 7) + f1 n
  ;;
  f3 is O(n)

  Intuitively it looked something like O(n).
  To prove it: I formed the recurrence relation:
  T(n) = T(n/7) + T(5n/7) + n
  Then showed that T(n) = 7n satisfied the relation.
  T(n) = 7(n/7) + 7(5n/7) + n
  T(n) = n + 5n + n
  T(n) = 7n
  So T(n) = O(n)
  So the time complexity of f3 is O(n)
*)

(** A mutable binary tree is either a leaf or a branch node. Nodes contain
 *  a label and references to two other mutable binary trees. Present the
 *  OCaml type declaration for mutable binary trees.                          *)
 type 'a muttree = Leaf | Branch of 'a ref * 'a muttree ref * 'a muttree ref;;

(** Describe how to use this datatype to implement (mutable) binary
 *  search trees.  Note: 'search' trees are duplicate-free.                   *)
 (* Each tree contains references to its label and references to the two
 sub-trees. This means that the tree holds references only and hence is
 entirely mutable                                                             *)

(** Give OCaml code for the lookup and update operations. The update
 *  operation must never copy existing tree nodes.                            *)
module MutTrees : sig
  val lookup : 'a -> 'a muttree -> 'a ref
  val update : 'a -> 'a -> 'a muttree -> unit
end = struct
  let rec lookup n = function
    | Leaf -> raise Not_found
    | Branch (x, _, _) when !x = n -> x
    | Branch (x, l, _) when !x > n -> lookup n !l
    | Branch (_, _, r) -> lookup n !r
  ;;

  let rec update a b t =
    lookup a t := b
  ;;
end

(** I took the liberty of making new modules for the code which did not already
 *  have modules                                                              *)

module MutList = struct
  (** Consider a polymorphic mutable list: one where the CONS cells hold an
   *  immutable value and a mutable reference to the next CONS cell.  END
   *  marks the end of such a list.  Provide a suitable OCaml type definition.*)

  type 'a polymutlist = E | N of 'a * 'a polymutlist ref;;

  (** Show how to build a mutable list of integers that contains a cycle.     *)

  let rec t = N (0, ref t);;

  (** Write a function 'isCyclic' that, given a reference to a value of your
   *  polymorphic mutable list type, returns a boolean indicating whether the
   *  list contains a cycle. Ensure that your function works for all type
   *  specialisations of the polymorphic type, including when 'a is a
   *  function!                                                               *)
   (** Hint: two references have 'reference equality' if ref1 == ref2.  Note
    *  the double '==' for reference equality '=' gives structural equality,
    *  which is different).                                                   *)
  let isCyclic l =
    let rec incCycle acc = function
      | E -> false
      | N (v, n) -> List.exists ((==) n) acc || incCycle (n :: acc) !n
    in
    incCycle [] l
  ;;
end

(* -------------------------------------------------------------------------- *)
(* EXTENSION QUESTIONS                                                        *)
(* -------------------------------------------------------------------------- *)

(* https://www.cl.cam.ac.uk/teaching/exams/pastpapers/y1996p1q6.pdf           *)

module LazyStreams = struct
  (** Give the declaration of an ML datatype that could be used in the
   * representation of a lazy list of integers, and illustrate its use by
   * defining a function ints that when given an argument n yields a lazy
   * list of integers from n to infinity.                                     *)

  type 'a stream = N of 'a * (unit -> 'a stream);;
  let rec ints n = N (n, fun () -> ints (n + 1));;

  (** The decimal representation of a real number in the range 0 to 1 is to be
   *  represented as an infinite sequence of the decimal digits following the
   *  decimal point (0.d1d2...). Define a function mknumb which when applied to
   *  the digit function dig will construct a lazy list of these digits where
   *  the ith digit (di) is given by dig i                                    *)

  let rec mknumb dig i = N (dig i, fun () -> mknumb dig (i + 1));;

  (** Suppose we have an infinite sequence of such numbers [r1, r2, ...], in
   *  which the digits of the decimal expansion of ri are given by the digit
   *  function fi, and that the collection of digit functions is represented by
   *  the lazy list [f1, f2, ...]. Define suitable datatypes for the list of
   *  numbers and the list of digit functions.                                *)

  type 'a sequence = S of 'a stream * (unit -> 'a sequence);;
  type 'a funstream = F of (int -> int) * (unit -> 'a funstream);;

  (** Define a function newnumb which when given the lazy list of digit
   *  functions will yield a lazy list of digits that have the property that
   *  its ith digit differs from the ith digit of ri.                         *)

  let newnumb funstr =
    let rec rnew i = function
      | F (f, n) -> S (mknumb (fun f -> ((+) 1) f mod 10) i, fun () -> rnew (i + 1) (n ()))
    in
    rnew 1 funstr
  ;;
end

(** More practice with lazy data structures:
 *  https://www.cl.cam.ac.uk/teaching/exams/pastpapers/y2005p1q6.pdf          *)
module LazyData = struct
  type 'a tree = Twig of 'a
              | Br of 'a * 'a tree * 'a tree;;
(*
Write an ML function find path such that find path p t returns some path
in t whose sum satisfies the boolean-valued function p. If no such path exists,
the function should raise an exception.
*)

  let find p =
    let rec dfs sum path = function
      | Twig (v) when p (sum + v) -> List.rev path
      | Twig (_) -> raise Not_found
      | Br (v, l, r) ->
        try dfs (sum + v) (v :: path) l
        with Not_found -> dfs (sum + v) (v :: path) r
    in
    dfs 0 []
  ;;

(*
Write an ML function all paths such that all paths p t returns the list of
all paths in t whose sums satisfy the boolean-valued function p.
*)

  let allpaths p =
    let rec dfs sum paths lr = function
      | Twig (v) when p (sum + v) -> (List.rev lr) :: paths
      | Twig (_) -> paths
      | Br (v, l, r) ->
        (dfs (sum + v) (dfs (sum + v) paths (v :: lr) l) (v :: lr) r)
    in
    dfs 0 [] []
  ;;

(*
Write an ML function all pathq that is analogous to all paths but returns
a lazy list of paths. For full credit, your function should find paths upon
demand rather than all at once. [Hint: try adding solutions to an accumulating
argument.]
*)

  type 'a stream = E | N of 'a * (unit->'a stream);;

  let all_pathq p t =
    let rec nextpath newpath prev lr path sum = function
      | Twig (v) when newpath && p (v + sum) ->
          N (List.rev (v :: path), fun () -> nextpath false (List.rev lr) [] [] 0 t)
      | Twig (_) -> raise Not_found
      | Br (v, l, r) when newpath ->
            (try nextpath newpath prev (false :: lr) (v :: path) (v + sum) l
            with Not_found -> nextpath newpath prev (true :: lr) (v :: path) (v + sum) r)
      | Br (v, l, r) ->
          match prev with
            | true :: pp -> nextpath newpath pp (true :: lr) (v :: path) (v + sum) r
            | false :: pp ->
              (try nextpath newpath pp (false :: lr) (v :: path) (v + sum) l
              with Not_found -> nextpath true pp (true :: lr) (v :: path) (v + sum) r)
            | _ -> assert false
    in
    nextpath true [] [] [] 0 t
  ;;

  (*
  Essentially this stores a copy of the previous route, navigates there and then
  continues with a find for the next path.

  This function checks against the most recently generated solution and uses it
  to disregard parts of the tree.
  When we generate a solution, we encode the route to the solution
  (using false for left and true for right).
  Then when going down the tree we make sure we do not enter any node to the
  left of the newest solution.
  This means that the first time we reach a twig we are guaranteed that it is
  the most recent solution, however the second time that we reach a node,
  it will be a new route which has not been explored before.
  *)

  (*
  newpath is a bool indicating whether the current path has been searched
  before

  prev is a bool list containing the moves in the previous solution
  (so that the function can navigate there for the next search)

  lr (left/right) is a bool list containing the moves in the current search
  (creating prev for the next call)

  path is an int list containing the nodes on the current path

  sum is the sum of the items in path -- technically unnecessary BUT it means
  a List.fold_left (+) 0 path is not needed for every twig so it's more optimal
  *)
end
[@warning "-20"] [@warning "-39"]
