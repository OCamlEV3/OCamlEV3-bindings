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

type white = White of int

type values =
  white * rgb


type mode =
    NXT_Col_color | NXT_Col_red   | NXT_Col_green
  | NXT_Col_blue  | NXT_Col_white | NXT_Col_norm
  | NXT_Col_all   | NXT_Col_raw

let create =
  fun port ->
    let path = find_sensor "ht-nxt-color-v2" port "i2c1" in
    NXTColorSensor (path, port)

let get_mode = function
  | NXTColorSensor (where, port) ->
    match Files.kfread @@ where ^ "mode" with
    | "COLOR" -> NXT_Col_color
    | "RED"   -> NXT_Col_red
    | "GREEN" -> NXT_Col_green
    | "BLUE"  -> NXT_Col_blue
    | "WHITE" -> NXT_Col_white
    | "NORM"  -> NXT_Col_norm
    | "ALL"   -> NXT_Col_all
    | "RAW"   -> NXT_Col_raw
    | _       -> assert false

let set_mode =
  fun sensor mode -> match sensor with
  | NXTColorSensor (where, port) ->
    Files.kfwrite (where ^ "mode") @@ match mode with
    | NXT_Col_color -> "COLOR"
    | NXT_Col_red   -> "RED"
    | NXT_Col_green -> "GREEN"
    | NXT_Col_blue  -> "BLUE"
    | NXT_Col_white -> "WHITE"
    | NXT_Col_norm  -> "NORM"
    | NXT_Col_all   -> "ALL"
    | NXT_Col_raw   -> "RAW"

let check_mode =
  fun sensor what ->
    if get_mode sensor <> what then raise Incorrect_mode

let get_color = function
  | NXTColorSensor (where, _) as s ->
      check_mode s NXT_Col_color;
      read_at where 0

let get_component what = function
  | NXTColorSensor (where, _) as s ->
    let mode = match what with
      | `Red   -> NXT_Col_red
      | `Blue  -> NXT_Col_blue
      | `Green -> NXT_Col_green
      | `White -> NXT_Col_white
    in
    check_mode s mode;
    read_at where 0

let get_norm = function
  | NXTColorSensor (where, _) as s ->
    check_mode s NXT_Col_norm;
    let r = read_at where in Color_sensors.(
      White (r 0), (Red (r 1), Green (r 2), Blue (r 3))
    )

let get_raw_rgb = function
  | NXTColorSensor (where, _) as s ->
    check_mode s NXT_Col_raw;
    let r = read_at where in Color_sensors.(
      White (r 0), (Red (r 1), Green (r 2), Blue (r 3))
    )

let get_all = function
  | NXTColorSensor (where, _) as s ->
    check_mode s NXT_Col_all;
    let r = read_at where in Color_sensors.(
      White (r 0), (Red (r 1), Green (r 2), Blue (r 3))
    )

