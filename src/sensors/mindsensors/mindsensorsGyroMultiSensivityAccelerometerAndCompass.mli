
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

(** Implementation of the sensor mindsensorsGyroMultiSensivityAccelerometerAndCompass.
    Documentation {{:http://www.ev3dev.org/docs/sensors/mindsensors.com-gyro-multisensitivity-accelerometer-and-compass/} page} *)
open Device
open Port
open Sensor

module type MINDSENSORS_GYRO_MULTI_SENSIVITY_ACCELEROMETER_AND_COMPASS = sig
  
  type mindsensors_gyro_multi_sensivity_accelerometer_and_compass_modes = 
    | TILT (** Constructor for TILT mode. *)
    | ACCESS (** Constructor for ACCESS mode. *)
    | COMPASS (** Constructor for COMPASS mode. *)
    | MAG (** Constructor for MAG mode. *)
    | GYRO (** Constructor for GYRO mode. *)
  (** Type for modes of the sensor mindsensors_gyro_multi_sensivity_accelerometer_and_compass_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := mindsensors_gyro_multi_sensivity_accelerometer_and_compass_modes
  
  val tilt : int_tuple3 ufun
  (** [tilt ()] returns the current value of the mode tilt *)
  
  val acceleration : int_tuple3 ufun
  (** [acceleration ()] returns the current value of the mode acceleration *)
  
  val compass : int ufun
  (** [compass ()] returns the current value of the mode compass *)
  
  val magnetic_field : int_tuple3 ufun
  (** [magnetic_field ()] returns the current value of the mode magnetic_field *)
  
  val gyroscope : int_tuple3 ufun
  (** [gyroscope ()] returns the current value of the mode gyroscope *)
  
end

module MindsensorsGyroMultiSensivityAccelerometerAndCompass (DI : Device.DEVICE_INFO) (P: Port.OUTPUT_PORT) : MINDSENSORS_GYRO_MULTI_SENSIVITY_ACCELEROMETER_AND_COMPASS
(** Implementation of Mindsensors Gyro Multi Sensivity Accelerometer And Compass. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

