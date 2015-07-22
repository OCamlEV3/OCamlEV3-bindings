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

module type MONAD = sig
  type 'a m

  val bind   : 'a m -> ('a -> 'b m) -> 'b m
  val map    : ('a -> 'b) -> 'a m -> 'b m
  val return : 'a -> 'a m
  val fail   : exn -> 'a m

  module INFIX :
  sig
    val ( >>= ) : 'a m -> ('a -> 'b m) -> 'b m
    val ( =<< ) : ('a -> 'b m) -> 'a m -> 'b m
    val ( >|= ) : 'a m -> ('a -> 'b) -> 'b m
    val ( =|< ) : ('a -> 'b) -> 'a m -> 'b m
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

module IO_FONCTOR =
  functor (M : MONAD) ->
  functor (R : sig
             val read : string -> string M.m
             val write : string -> string -> unit M.m
           end) ->
  struct
    open M.INFIX

    type 'a m= 'a M.m

    let r f = (fun x -> M.return (f x))

    let read filename translater =
      R.read filename >>= fun data ->
      translater data

    let read_string filename =
      read filename (r (fun x -> x))

    let read_int filename =
      read filename (r int_of_string)

    let write filename translater data =
      translater data >>= fun translated_data ->
      R.write filename translated_data

    let write_string filename data =
      write filename (r (fun x -> x)) data

    let write_int filename data =
      write filename (r string_of_int) data
  end


(*
   Usual core declaration
*)

module Monad : MONAD = struct
type 'a m = 'a

  let bind x f = f x
  let map f x  = f x
  let return x = x
  let fail ex  = raise ex

  module INFIX =
  struct
    let ( >>= )      = bind
    let ( =<< )  f x = bind x f
    let ( >|= )  x f = map f x
    let ( =|< )      = map
    let ( >>=? ) x y = x >>= (fun _ -> y)
    let ( >>   ) x y = x >>= (fun () -> y)
  end
end

module Core : CORE = struct

  include Monad

  module IO = IO_FONCTOR(Monad)(struct
      let read path =
        let in_ = open_in path in
        let line = input_line in_ in
        close_in in_; return line

      let write path msg =
        let out = open_out path in
        output_string out msg;
        return ()
    end)

end


(*
   Lwt Core
*)

module LwtMonad : MONAD with type 'a m = 'a Lwt.t = struct
  type 'a m = 'a Lwt.t

  let bind   = Lwt.bind
  let map    = Lwt.map
  let return = Lwt.return
  let fail   = Lwt.fail

  module INFIX = struct
    let ( >>= ) = Lwt.Infix.( >>= )
    let ( =<< ) = Lwt.Infix.( =<< )
    let ( >|= ) = Lwt.Infix.( >|= )
    let ( =|< ) = Lwt.Infix.( =|< )
    let ( >>=? ) x y = x >>= (fun _ -> y)
    let ( >>   ) x y = x >>= (fun () -> y)
  end
end

module LwtCore : CORE with type 'a m = 'a Lwt.t = struct

  include LwtMonad

  module IO = IO_FONCTOR(LwtMonad)(struct
      open INFIX

      let read filename =
        Lwt_io.with_file ~flags:[Unix.O_RDONLY]
          ~mode:Lwt_io.input filename
          Lwt_io.read_line

      let write filename msg =
        Lwt_io.with_file ~flags:[Unix.O_WRONLY]
          ~mode:Lwt_io.output filename
          (fun channel -> Lwt_io.write_line channel msg)
    end)

end
