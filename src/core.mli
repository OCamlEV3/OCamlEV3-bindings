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

exception Invalid_file of string

module type MONAD =
sig
  type 'a m

  val bind   : 'a m -> ('a -> 'b m) -> 'b m
  val map    : ('a -> 'b) -> 'a m -> 'b m
  val return : 'a -> 'a m
  val fail   : exn -> 'a m

  module INFIX :
  sig
    val ( >>=  ) : 'a m -> ('a -> 'b m) -> 'b m
    val ( =<<  ) : ('a -> 'b m) -> 'a m -> 'b m
    val ( >|=  ) : 'a m -> ('a -> 'b) -> 'b m
    val ( =|<  ) : ('a -> 'b) -> 'a m -> 'b m
    val ( >>=? ) : 'a m -> 'b m -> 'b m
    val ( >>   ) : unit m -> 'b m -> 'b m
  end
end

module type IO = sig
  type 'a m
  val read         : string -> (string -> 'a m) -> 'a m
  val read_string  : string -> string m
  val read_int     : string -> int m
  val write        : string -> ('a -> string m) -> 'a -> unit m
  val write_string : string -> string -> unit m
  val write_int    : string -> int -> unit m
end

module type CORE = sig
  include MONAD
  module IO : IO with type 'a m = 'a m
end

module Core    : CORE
module LwtCore : CORE with type 'a m = 'a Lwt.t
