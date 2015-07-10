
open Core

exception Invalid_value of string
exception Connection_failed of string

module type PATH = sig
  val path : string
  val exception_on_fail : bool
end

module type DEVICE =
  sig
    type 'a m
    val is_connected : unit -> bool m
    val get_path : unit -> string m
  end

module Device (M : MONAD) (P : PATH) : DEVICE with type 'a m = 'a M.m

