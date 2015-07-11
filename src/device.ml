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

open Core
open Port

exception Invalid_value     of string
exception Connection_failed of string
exception Is_not_connected  of string

module type PATH = sig
  val path : string
  val exception_on_fail : bool
end

module type DEVICE = sig
  type 'a m
  val connect : unit -> unit m
  val is_connected : unit -> bool m
  val get_path : unit -> string m
end

module Device (M : MONAD) (P : PATH) =
struct
  type 'a m = 'a M.m

  let path = P.path

  let connected = ref false

  let fail () =
    if P.exception_on_fail then M.fail (Connection_failed path)
    else M.return ()

  let connect () =
    try
      begin match Sys.is_directory path with
      | true  ->
        M.return (connected := true)
      | false -> fail ()
      end
    with Sys_error _ ->
      fail ()


  let is_connected () = M.return !connected

  let get_path () = M.return path
end
