
open Core
open Port

let connected_device = Hashtbl.create 8

exception Invalid_value of string
exception Connection_failed of string

module type PATH = sig
  val path : string
  val exception_on_fail : bool
end

module type DEVICE = sig
  type 'a m
  val is_connected : unit -> bool m
  val get_path : unit -> string m
end

module Device (M : MONAD) (P : PATH) =
struct
  type 'a m = 'a M.m

  let path = P.path

  let is_connected () =
    match Sys.is_directory path with
    | true  ->
      M.return true

    | false ->
      if P.exception_on_fail then
        raise (Connection_failed path)
      else
        M.return false

  let get_path () = M.return path

  let _ = is_connected ()
end
