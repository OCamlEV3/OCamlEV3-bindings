
(*****************************************************************************)
(* The MIT License (MIT)                                                     *)
(*                                                                           *)
(* Copyright (c) 2015 OCamlEV3                                               *)
(*  Loïc Runarvot <loic.runarvot[at]gmail.com>                               *)
(*  Nicolas Tortrat-Gentilhomme <nicolas.tortrat[at]gmail.com>               *)
(*  Nicolas Raymond <noci.64[at]orange.fr>                                   *)
(*                                                                           *)
(* Permission is hereby granted, free of charge, to any person obtaining a   *)
(* copy of this software and associated documentation files (the "Software"),*)
(* to deal in the Software without restriction, including without limitation *)
(* the rights to use, copy, modify, merge, publish, distribute, sublicense,  *)
(* and/or sell copies of the Software, and to permit persons to whom the     *)
(* Software is furnished to do so, subject to the following conditions:      *)
(*                                                                           *)
(* The above copyright notice and this permission notice shall be included   *)
(* in all copies or substantial portions of the Software.                    *)
(*                                                                           *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS   *)
(* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF                *)
(* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.    *)
(* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY      *)
(* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT *)
(* OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR  *)
(* THE USE OR OTHER DEALINGS IN THE SOFTWARE.                                *)
(*****************************************************************************)

(** Implementation of the sensor legoEv3GyroSensor.
    Documentation {{:http://www.ev3dev.org/docs/sensors/lego-ev3-gyro-sensor/} page} *)
open Device
open Port
open Sensor

module type LEGO_EV3_GYRO_SENSOR = sig
  
  type lego_ev3_gyro_sensor_modes = 
    | GYRO_ANG (** Constructor for GYRO_ANG mode. *)
    | GYRO_RATE (** Constructor for GYRO_RATE mode. *)
    | GYRO_FAS (** Constructor for GYRO_FAS mode. *)
    | GYRO_G_AND_A (** Constructor for GYRO_G_AND_A mode. *)
    | GYRO_CAL (** Constructor for GYRO_CAL mode. *)
  (** Type for modes of the sensor lego_ev3_gyro_sensor_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := lego_ev3_gyro_sensor_modes
  
  val angle : int ufun
  (** [angle ()] returns the current value of the mode angle *)
  
  val rotational_speed : int ufun
  (** [rotational_speed ()] returns the current value of the mode rotational_speed *)
  
  val raw_values : int ufun
  (** [raw_values ()] returns the current value of the mode raw_values *)
  
  val angle_and_rotational_speed : int_tuple2 ufun
  (** [angle_and_rotational_speed ()] returns the current value of the mode angle_and_rotational_speed *)
  
  val calibration : int_tuple4 ufun
  (** [calibration ()] returns the current value of the mode calibration *)
  
end

module LegoEv3GyroSensor (DI : Device.DEVICE_INFO) (P: Port.OUTPUT_PORT) : LEGO_EV3_GYRO_SENSOR
(** Implementation of Lego Ev3 Gyro Sensor. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

