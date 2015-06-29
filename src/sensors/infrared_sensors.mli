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
(**
    Implementation of infrared sensor
 *)

open Common_sensors

(** Represent the type of the channel *)
type channel = Channel of (int * int)

(** Type of the seeker *)
type seek = channel * channel * channel * channel

(** Type of the infrared sensor *)
type mode = Ir_prox | Ir_seek | Ir_remote

(** [get_mode sensor] return the mode of the infrared sensor *)
val get_mode : infraredsensor sensors -> mode

(** [set_mode sensor mode] set the mode *)
val set_mode : infraredsensor sensors -> mode -> unit

(** [create port] create the infrared sensor at [port]. *)
val create : port -> infraredsensor sensors

(** [get_proximity sensor] return the proximity value *)
val get_proximity : infraredsensor sensors -> int

(** [get_seeker sensor] return the seek value *)
val get_seeker : infraredsensor sensors -> seek

(** [get_remote sensor] return the remote value *)
val get_remote : infraredsensor sensors -> (int * int * int * int)

