(************************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team     *)
(* <O___,, *   INRIA - CNRS - LIX - LRI - PPS - Copyright 1999-2012     *)
(*   \VV/  **************************************************************)
(*    //   *      This file is distributed under the terms of the       *)
(*         *       GNU Lesser General Public License Version 2.1        *)
(************************************************************************)

open Names
open Univ
open Term
open Environ
open Declarations
open Entries
open Mod_subst

(** Various operations on modules and module types *)


val module_body_of_type : module_path -> module_type_body  -> module_body 

val module_type_of_module : module_path option -> module_body ->
  module_type_body

val destr_functor :
  struct_expr_body -> MBId.t * module_type_body * struct_expr_body

val subst_struct_expr :  substitution -> struct_expr_body -> struct_expr_body

val subst_signature : substitution -> structure_body -> structure_body

val add_signature :
  module_path -> structure_body -> delta_resolver -> env -> env

(** adds a module and its components, but not the constraints *)
val add_module : module_body -> env -> env

val check_modpath_equiv : env -> module_path -> module_path -> unit

val strengthen : module_type_body -> module_path -> module_type_body

val inline_delta_resolver :
  env -> inline -> module_path -> MBId.t -> module_type_body ->
  delta_resolver -> delta_resolver

val strengthen_and_subst_mb : module_body -> module_path -> bool -> module_body

val subst_modtype_and_resolver : module_type_body -> module_path ->
  module_type_body

val clean_bounded_mod_expr : struct_expr_body -> struct_expr_body

(** Errors *)

type signature_mismatch_error =
  | InductiveFieldExpected of mutual_inductive_body
  | DefinitionFieldExpected
  | ModuleFieldExpected
  | ModuleTypeFieldExpected
  | NotConvertibleInductiveField of Id.t
  | NotConvertibleConstructorField of Id.t
  | NotConvertibleBodyField
  | NotConvertibleTypeField of env * types * types
  | NotSameConstructorNamesField
  | NotSameInductiveNameInBlockField
  | FiniteInductiveFieldExpected of bool
  | InductiveNumbersFieldExpected of int
  | InductiveParamsNumberField of int
  | RecordFieldExpected of bool
  | RecordProjectionsExpected of Name.t list
  | NotEqualInductiveAliases
  | NoTypeConstraintExpected

type module_typing_error =
  | SignatureMismatch of Label.t * structure_field_body * signature_mismatch_error
  | LabelAlreadyDeclared of Label.t
  | ApplicationToNotPath of module_struct_entry
  | NotAFunctor of struct_expr_body
  | IncompatibleModuleTypes of module_type_body * module_type_body
  | NotEqualModulePaths of module_path * module_path
  | NoSuchLabel of Label.t
  | IncompatibleLabels of Label.t * Label.t
  | SignatureExpected of struct_expr_body
  | NoModuleToEnd
  | NoModuleTypeToEnd
  | NotAModule of string
  | NotAModuleType of string
  | NotAConstant of Label.t
  | IncorrectWithConstraint of Label.t
  | GenerativeModuleExpected of Label.t
  | NonEmptyLocalContect of Label.t option
  | LabelMissing of Label.t * string

exception ModuleTypingError of module_typing_error

val error_existing_label : Label.t -> 'a

val error_application_to_not_path : module_struct_entry -> 'a

val error_incompatible_modtypes :
  module_type_body -> module_type_body -> 'a

val error_signature_mismatch :
  Label.t -> structure_field_body -> signature_mismatch_error -> 'a

val error_incompatible_labels : Label.t -> Label.t -> 'a

val error_no_such_label : Label.t -> 'a

val error_signature_expected : struct_expr_body -> 'a

val error_no_module_to_end : unit -> 'a

val error_no_modtype_to_end : unit -> 'a

val error_not_a_module : string -> 'a

val error_not_a_constant : Label.t -> 'a

val error_incorrect_with_constraint : Label.t -> 'a

val error_generative_module_expected : Label.t -> 'a

val error_non_empty_local_context : Label.t option -> 'a

val error_no_such_label_sub : Label.t->string->'a
