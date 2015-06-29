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
(** Implementation of a NXT Color Sensor *)

open Common_sensors

(** White component *)
type white = White of int

(** Values return by the sensor *)
type values =
  white * rgb

(** The mode of the NXT Color Sensor. *)
type mode =
  | NXT_Col_color
  (** Color mode. One value between 0 and 17. *)
  | NXT_Col_red
  (** Red component. One value between 0 and 255. *)
  | NXT_Col_green
  (** Green component. One value between 0 and 255. *)
  | NXT_Col_blue
  (** Blue component. One value between 0 and 255. *)
  | NXT_Col_white
  (** White component. One value between 0 and 255. *)
  | NXT_Col_norm
  (** Normalized component. *)
  | NXT_Col_all
  (** All colors. Three value (RGB) with values between 0 and 255. *)
  | NXT_Col_raw
  (** Raw colors. Three value (RGB) with values between 0 and 255. *)

(** [create port] create the port and returns a nxtcolorsensor *)
val create : port -> nxtcolorsensor sensors

(** [get_mode sensor] returns the mode of the color sensor. *)
val get_mode : nxtcolorsensor sensors -> mode

(** [set_mode sensor mode] set the mode of the color sensor. *)
val set_mode : nxtcolorsensor sensors -> mode -> unit

(** [get_color sensor] returns the color value of [sensor]. *)
val get_color : nxtcolorsensor sensors -> int

(** [get_component what sensor] return the correct component value. *)
val get_component :
  [< `Red | `Blue | `Green | `White ] -> nxtcolorsensor sensors -> int

(** [get_norm sensor] returns the normalized rgb color of [sensor]. *)
val get_norm : nxtcolorsensor sensors -> values

(** [get_raw_rgb sensor] returns the rgb color of [sensor]. *)
val get_raw_rgb : nxtcolorsensor sensors -> values

(** [get_all sensor] returns the color and the rgb color of [sensor]. *)
val get_all : nxtcolorsensor sensors -> values
