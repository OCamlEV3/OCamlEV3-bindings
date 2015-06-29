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
    Common functions for every sensors
 *)

(** Represents the type of touch sensor *)
type touchsensor         = TS

and  nxtcolorsensor      = NXTCS

(** Represents the type of color sensor *)
and  colorsensor         = CS

(** Represents the type of the ultrasonic sensor *)
and  nxtultrasonicsensor = NXTUS

(** Represents the type of the gyro sensor *)
and  gyrosensor          = GS

(** Represents the type of the infrared sensor *)
and  infraredsensor      = IS

(** Path to the sensor *)
and  path = string

(** The port of the sensor *)
and  port = string

(** Global sensor type *)
type _ sensors =
  | TouchSensor         : (path * port) -> touchsensor         sensors
  | ColorSensor         : (path * port) -> colorsensor         sensors
  | NXTColorSensor      : (path * port) -> nxtcolorsensor      sensors
  | NXTUltrasonicSensor : (path * port) -> nxtultrasonicsensor sensors
  | GyroSensor          : (path * port) -> gyrosensor          sensors
  | InfraredSensor      : (path * port) -> infraredsensor      sensors

type red   = Red   of int
and  green = Green of int
and  blue  = Blue  of int
and  rgb   = red * green * blue


(** [sensor_to_string sensor] return the string value of the sensor.
    In EV3, it correspond to the driver_name. *)
val sensor_to_string : 'a sensors -> string

(** Value that represent the port 1 *)
val in1 : port

(** Value that represent the port 2 *)
val in2 : port

(** Value that represent the port 3 *)
val in3 : port

(** Value that represent the port 4 *)
val in4 : port

(** Exception raised when the sensor is invalid. *)
exception Invalid_sensor of string

(** Exception raised when the driver_name is not the same. *)
exception Initialization_failed of string

(** Exception raise when the sensor mode is incorrect. *)
exception Incorrect_mode

(** [find_sensor what port address] try to find the sensor [what] at
    the port [port]. *)
val find_sensor : string -> port -> string -> string

(** Exception raised when the value is invalid. **)
exception Invalid_value of int

val read_at : string -> int -> int
