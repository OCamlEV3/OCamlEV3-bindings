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

open Monads

type usage =
  | ReleaseAfterUse
  | NeverRelease

type mode =
  | Read
  | Write
  | Both

exception Invalid_file of string

module type UNIX =
sig
  type 'a m
  type filedescr
  val openfile : string -> Unix.open_flag list -> Unix.file_perm -> filedescr m
  val close : filedescr -> unit m
  val lseek : filedescr -> int -> Unix.seek_command -> int m
  val read  : filedescr -> string -> int -> int -> int m
  val write : filedescr -> string -> int -> int -> int m
end

module SimpleUnix : UNIX with type 'a m = 'a SimpleMonad.m =
struct
  type 'a m = 'a SimpleMonad.m
  type filedescr = Unix.file_descr

  let openfile str flags fp = SimpleMonad.return (Unix.openfile str flags fp)
  let close fd = SimpleMonad.return (Unix.close fd)
  let lseek fd i s = SimpleMonad.return (Unix.lseek fd i s)
  let read fd s i j = SimpleMonad.return (Unix.read fd s i j)
  let write fd s i j = SimpleMonad.return (Unix.write fd s i j)
end

module LwtUnix : UNIX with type 'a m = 'a LwtMonad.m =
struct
  type 'a m = 'a LwtMonad.m
  type filedescr = Lwt_unix.file_descr

  let openfile = Lwt_unix.openfile
  let close    = Lwt_unix.close
  let lseek    = Lwt_unix.lseek
  let read     = Lwt_unix.read
  let write    = Lwt_unix.write
end

module type MonadicFileManager = sig
  type 'a m
  val store_filename : ?usage:usage -> ?mode:mode -> string -> unit m
  val write : ?usage:usage -> string -> string -> unit m
  val read : ?usage:usage -> string -> string m
end

module MonadicFileManager (M : MONAD) (U : UNIX with type 'a m = 'a M.m) =
struct

  open M.INFIX

  type 'a m = 'a M.m

  let file_table = Hashtbl.create 4

  let add usage key value =
    match usage with
    | ReleaseAfterUse -> M.return ()
    | NeverRelease    -> M.return (Hashtbl.add file_table key value)

  let exists elt = M.return (Hashtbl.mem file_table elt)
  let find   elt = M.return (Hashtbl.find file_table elt)
  let remove elt = M.return (Hashtbl.remove file_table elt)

  let unix_flag_of_flag flag = M.return (match flag with
    | Read  -> Unix.O_RDONLY
    | Write -> Unix.O_WRONLY
    | Both  -> Unix.O_RDWR
  )

  let store_and_return usage mode filename =
    match Sys.file_exists filename with
    | true ->
      begin match Filename.is_relative filename with
      | true ->
        raise (Invalid_file (Printf.sprintf "`%s' have to be absolute" filename))
      | false ->
        unix_flag_of_flag mode            >>= fun flag ->
        U.openfile filename [flag] 0o640  >>= fun fd ->
        add usage filename (fd, usage)    >>
        M.return (fd, usage)
      end
    | false ->
      raise (Invalid_file (Printf.sprintf "`%s' doesn't exists." filename))

  let store_filename ?(usage = ReleaseAfterUse) ?(mode = Both) filename =
    store_and_return usage mode filename >>=?
    M.return ()

  let find_or_create filename mode usage =
    exists filename >>= function
    | true  -> find filename
    | false -> store_and_return usage mode filename

  let check_file_usage filename fd usage =
    match usage with
    | ReleaseAfterUse ->
      U.close fd >>= fun () ->
      remove filename
    | NeverRelease ->
      M.return ()

  let write ?(usage = ReleaseAfterUse) filename message =
    find_or_create filename Write usage          >>= fun (fd, usage) ->
    U.lseek fd 0 Unix.SEEK_SET                   >>=?
    U.write fd message 0 (String.length message) >>=?
    check_file_usage filename fd usage

  let read ?(usage = ReleaseAfterUse) filename =
    find_or_create filename Read usage      >>= fun (fd, usage) ->
    U.lseek fd 0 Unix.SEEK_SET              >>=?
    let buffer = Bytes.create 64 in
    U.read fd buffer 0 64                   >>=?
    let message = Bytes.to_string buffer in
    check_file_usage filename fd usage      >>
    M.return message

end

module SimpleFileManager = MonadicFileManager(SimpleMonad)(SimpleUnix)
module LwtFileManager    = MonadicFileManager(LwtMonad)(LwtUnix)

