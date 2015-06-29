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

type mode = US_DIST_CM | US_DIST_IN | US_SI_CM | US_SI_IN | US_LISTEN

let create =
  fun port ->
    let path = find_sensor "lego-nxt-us" port "i2c1" in
    NXTUltrasonicSensor (path, port)

let get_mode = function
  | NXTUltrasonicSensor (where, port) ->
    match Files.kfread @@ where ^ "mode" with
    | "US-DIST-CM" -> US_DIST_CM
    | "US-DIST-IN" -> US_DIST_IN
    | "US-SI-CM"   -> US_SI_CM
    | "US-SI-IN"   -> US_SI_IN
    | "US-LISTEN"  -> US_LISTEN
    | _            -> assert false

let set_mode =
  fun sensor mode -> match sensor with
    | NXTUltrasonicSensor (where, port) ->
        Files.kfwrite (where ^ "mode") @@ match mode with
        | US_DIST_CM -> "US-DIST-CM"
        | US_DIST_IN -> "US-DIST-IN"
        | US_SI_CM   -> "US-SI-CM"
        | US_SI_IN   -> "US-SI-IN"
        | US_LISTEN  -> "US-LISTEN"

let check_mode =
  fun sensor what ->
    if get_mode sensor <> what then raise Incorrect_mode

let get_cont_measurement_cm = function
  | NXTUltrasonicSensor (where, _) as s ->
    check_mode s US_DIST_CM;
    read_at where 0

let get_cont_measurement_inch = function
  | NXTUltrasonicSensor (where, _) as s ->
    check_mode s US_DIST_IN;
    read_at where 0

let get_in_measurement_cm = function
  | NXTUltrasonicSensor (where, _) as s ->
    check_mode s US_SI_CM;
    read_at where 0

let get_in_measurement_inch = function
  | NXTUltrasonicSensor (where, _) as s ->
    check_mode s US_SI_IN;
    read_at where 0

let listen = function
  | NXTUltrasonicSensor (where, _) as s ->
    check_mode s US_LISTEN;
    read_at where 0
