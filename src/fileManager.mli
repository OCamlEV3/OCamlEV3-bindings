
type usage =
  | ReleaseAfterUse
  | NeverRelease

type mode =
  | Read
  | Write
  | Both

exception Invalid_file of string


val store_filename : ?usage:usage -> ?mode:mode -> string -> unit

val write : ?usage:usage -> string -> string -> unit

val read : ?usage:usage -> string -> unit

