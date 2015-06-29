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
    Implementation of color sensor
 *)


open Common_sensors

(** The color sensor mode *)
type mode    = Col_reflect | Col_ambiant | Col_color | Rgb_raw

(** [create port] create the port and returns a colorsensor *)
val create : port -> colorsensor sensors

(** [get_mode sensor] returns the mode of the color sensor. *)
val get_mode : colorsensor sensors -> mode

(** [set_mode sensor mode] set the mode of the color sensor. *)
val set_mode : colorsensor sensors -> mode -> unit

(** [get_reflected_light sensor] returns the reflected light. *)
val get_reflected_light : colorsensor sensors -> int

(** [get_ambiant_light sensor] returns the ambiant light. *)
val get_ambiant_light : colorsensor sensors -> int

(** [get_color sensor] returns the color expected by the sensor. *)
val get_color : colorsensor sensors -> rgb option

(** [get_raw_rgb sensor] returns the sensor as rgb. *)
val get_raw_rgb : colorsensor sensors -> rgb

