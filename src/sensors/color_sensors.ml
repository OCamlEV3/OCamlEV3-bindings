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

type mode    = Col_reflect | Col_ambiant | Col_color | Rgb_raw

let create =
  fun port ->
    let path = find_sensor "lego-ev3-uart-29" port "" in
    ColorSensor (path, port)

let get_mode = function
  | ColorSensor (where, port) ->
    match Files.kfread @@ where ^ "mode" with
    | "COL-REFLECT" -> Col_reflect
    | "COL-AMBIANT" -> Col_ambiant
    | "COL-COLOR"   -> Col_color
    | "RGB-RAW"     -> Rgb_raw
    | _             -> assert false

let set_mode =
  fun sensor mode -> match sensor with
    | ColorSensor (where, port) ->
      Files.kfwrite (where ^ "mode") @@ match mode with
      | Col_reflect -> "COL-REFLECT"
      | Col_ambiant -> "COL-AMBIANT"
      | Col_color   -> "COL-COLOR"
      | Rgb_raw     -> "RGB-RAW"

let check_mode =
  fun sensor what ->
    if get_mode sensor <> what then raise Incorrect_mode

let get_reflected_light = function
  | ColorSensor (where, _) as s ->
    check_mode s Col_reflect;
    read_at where 0

let get_ambiant_light = function
  | ColorSensor (where, _) as s ->
    check_mode s Col_ambiant;
    read_at where 0

let get_color = function
  | ColorSensor (where, _) as s ->
    check_mode s Col_color;
    begin match read_at where 0 with
      | 0 -> None (* Unknown *)
      | 1 -> Some(Red 255, Green 255, Blue 255) (* Black  *)
      | 2 -> Some(Red   0, Green   0, Blue 255) (* Blue   *)
      | 3 -> Some(Red   0, Green 128, Blue   0) (* Green  *)
      | 4 -> Some(Red 255, Green 255, Blue   0) (* Yellow *)
      | 5 -> Some(Red 255, Green   0, Blue   0) (* Red    *)
      | 6 -> Some(Red   0, Green   0, Blue   0) (* White  *)
      | 7 -> Some(Red 165, Green  42, Blue  42) (* Brown  *)
      | _ -> assert false (* By documentation *)
    end

let get_raw_rgb = function
  | ColorSensor (where, _) as s ->
    check_mode s Rgb_raw;
    let r = read_at where in
    Red (r 0), Green (r 1), Blue (r 2)

