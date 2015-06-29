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
open Common_sensors

type channel = Channel of (int * int)

type seek = channel * channel * channel * channel

type mode = Ir_prox | Ir_seek | Ir_remote

let get_mode : infraredsensor sensors -> mode = function
  | InfraredSensor (where, port) ->
    match Files.kfread @@ where ^ "mode" with
    | "IR-PROX"   -> Ir_prox
    | "IR-SEEK"   -> Ir_seek
    | "IR-REMOTE" -> Ir_remote
    | _           -> assert false

let set_mode : infraredsensor sensors -> mode -> unit =
  fun sensor mode -> match sensor with
    | InfraredSensor (where, port) ->
      Files.kfwrite (where ^ "mode") @@ match mode with
      | Ir_prox   -> "IR-PROX"
      | Ir_seek   -> "IR-SEEK"
      | Ir_remote -> "IR-REMOTE"

let check_mode : infraredsensor sensors -> mode -> unit =
  fun sensor what ->
    if get_mode sensor <> what then raise Incorrect_mode

let create : port -> infraredsensor sensors =
  fun port ->
    let path = find_sensor "lego-ev3-uart-33" port "" in
    InfraredSensor (path, port)

let get_proximity : infraredsensor sensors -> int = function
  | InfraredSensor (where, port) as s ->
    check_mode s Ir_prox;
    read_at where 0

let get_seeker : infraredsensor sensors -> seek = function
  | InfraredSensor (where, port) as s ->
    check_mode s Ir_seek;
    let r = read_at where in (
      Channel (r 0, r 1), Channel (r 2, r 3),
      Channel (r 4, r 5), Channel (r 6, r 7)
    )

let get_remote : infraredsensor sensors -> (int * int * int * int) =
  function
  | InfraredSensor (where, port) as s ->
    check_mode s Ir_remote;
    let r = read_at where in
    r 0, r 1, r 2, r 3

