
type usage =
  | ReleaseAfterUse
  | NeverRelease

type mode =
  | Read
  | Write
  | Both

exception Invalid_file of string


module type MonadicFileManager = sig
  type 'a m
  val store_filename : ?usage:usage -> ?mode:mode -> string -> unit m
  val write : ?usage:usage -> string -> string -> unit m
  val read : ?usage:usage -> string -> string m
end

module SimpleFileManager : MonadicFileManager
module LwtFileManager    : MonadicFileManager

