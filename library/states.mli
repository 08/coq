(************************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team     *)
(* <O___,, *   INRIA - CNRS - LIX - LRI - PPS - Copyright 1999-2012     *)
(*   \VV/  **************************************************************)
(*    //   *      This file is distributed under the terms of the       *)
(*         *       GNU Lesser General Public License Version 2.1        *)
(************************************************************************)

(** {6 States of the system} *)

(** In that module, we provide functions to get
  and set the state of the whole system. Internally, it is done by
  freezing the states of both [Lib] and [Summary]. We provide functions
  to write and restore state to and from a given file. *)

val intern_state : string -> unit
val extern_state : string -> unit

type state
val freeze : marshallable:bool -> state
val unfreeze : state -> unit

(** {6 Rollback } *)

(** [with_heavy_rollback f h x] applies [f] to [x]. If this application
    ends on an exception, the wrapper [h] is applied to it, then
    the state of the whole system is restored as it was before applying [f],
    and finally the exception produced by [h] is raised. *)

val with_heavy_rollback : ('a -> 'b) -> (exn -> exn) -> 'a -> 'b

(** [without_rollback] is just like [with_heavy_rollback], except that
    no state is restored in case of exception. *)

val without_rollback : ('a -> 'b) -> (exn -> exn) -> 'a -> 'b

(** [with_state_protection f x] applies [f] to [x] and restores the
  state of the whole system as it was before applying [f] *)

val with_state_protection : ('a -> 'b) -> 'a -> 'b

