(******************************************************************************
 * The MIT License (MIT)                                                      *
 *                                                                            *
 * Copyright (c) 2015 OCamlEV3                                                *
 *  Loïc Runarvot <loic.runarvot[at]gmail.com>                                *
 *  Nicolas Tortrat-Gentilhomme <nicolas.tortrat[at]gmail.com>                *
 *  Nicolas Raymond <noci.64[at]orange.fr>                                    *
 *                                                                            *
 * Permission is hereby granted, free of charge, to any person obtaining a    *
 * copy of this software and associated documentation files (the "Software"), *
 * to deal in the Software without restriction, including without limitation  *
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,   *
 * and/or sell copies of the Software, and to permit persons to whom the      *
 * Software is furnished to do so, subject to the following conditions:       *
 *                                                                            *
 * The above copyright notice and this permission notice shall be included in *
 * all copies or substantial portions of the Software.                        *
 *                                                                            *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   *
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    *
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    *
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER        *
 * DEALINGS IN THE SOFTWARE.                                                  *
 *****************************************************************************)

type usage =
  | ReleaseAfterUse
  | NeverRelease

type mode =
  | Read
  | Write
  | Both

exception Invalid_file of string

module type MONAD =
sig
  type 'a m

  val bind   : 'a m -> ('a -> 'b m) -> 'b m
  val map    : ('a -> 'b) -> 'a m -> 'b m
  val return : 'a -> 'a m
  val fail   : exn -> 'a m

  module INFIX : sig
    val ( >>=  ) : 'a m -> ('a -> 'b m) -> 'b m
    val ( =<<  ) : ('a -> 'b m) -> 'a m -> 'b m
    val ( >|=  ) : 'a m -> ('a -> 'b) -> 'b m
    val ( =|<  ) : ('a -> 'b) -> 'a m -> 'b m
    val ( >>=? ) : 'a m -> 'b m -> 'b m
    val ( >>   ) : unit m -> 'b m -> 'b m
  end

  module UNIX : sig
    type filedescr
    val openfile : string -> Unix.open_flag list -> Unix.file_perm -> filedescr m
    val close : filedescr -> unit m
    val lseek : filedescr -> int -> Unix.seek_command -> int m
    val read  : filedescr -> string -> int -> int -> int m
    val write : filedescr -> string -> int -> int -> int m
  end

  module IO : sig
    val store_filename : ?usage:usage -> ?mode:mode -> string -> unit m
    val write : ?usage:usage -> string -> string -> unit m
    val read : ?usage:usage -> string -> string m
  end
end

module SimpleMonad : MONAD
module LwtMonad    : MONAD with type 'a m = 'a Lwt.t
