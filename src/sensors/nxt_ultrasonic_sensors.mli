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
(** Nxt Ultrasonic Sensor *)

open Common_sensors

type mode = US_DIST_CM | US_DIST_IN | US_SI_CM | US_SI_IN | US_LISTEN

(** [create port] create the port and returns a nxtultrasonicsensor *)
val create : port -> nxtultrasonicsensor sensors

(** [get_mode sensor] returns the mode of the nxtultrasonicsensor. *)
val get_mode : nxtultrasonicsensor sensors -> mode

(** [set_mode sensor mode] set the mode of the nxtultrasonicsensor. *)
val set_mode : nxtultrasonicsensor sensors -> mode -> unit

val get_cont_measurement_cm : nxtultrasonicsensor sensors -> int

val get_cont_measurement_inch : nxtultrasonicsensor sensors -> int

val get_in_measurement_cm : nxtultrasonicsensor sensors -> int

val get_in_measurement_inch : nxtultrasonicsensor sensors -> int

val listen : nxtultrasonicsensor sensors -> int
