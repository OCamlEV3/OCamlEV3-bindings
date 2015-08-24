
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

(** Implementation of the sensor microinfinityDigitalGyroscopeAndAccelerometer.
    Documentation {{:http://www.ev3dev.org/docs/sensors/microinfinity-digital-gyroscope-and-accelerometer/} page} *)
open Device
open Port
open Sensor

module type MICROINFINITY_DIGITAL_GYROSCOPE_AND_ACCELEROMETER = sig
  
  type microinfinity_digital_gyroscope_and_accelerometer_modes = 
    | ANGLE (** Constructor for ANGLE mode. *)
    | SPEED (** Constructor for SPEED mode. *)
    | ACCEL (** Constructor for ACCEL mode. *)
    | ALL (** Constructor for ALL mode. *)
  (** Type for modes of the sensor microinfinity_digital_gyroscope_and_accelerometer_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := microinfinity_digital_gyroscope_and_accelerometer_modes
  
  val angle : int ufun
  (** [angle ()] returns the current value of the mode angle *)
  
  val rotational_speed : int ufun
  (** [rotational_speed ()] returns the current value of the mode rotational_speed *)
  
  val acceleration : int_tuple3 ufun
  (** [acceleration ()] returns the current value of the mode acceleration *)
  
  val all_values : int_tuple5 ufun
  (** [all_values ()] returns the current value of the mode all_values *)
  
end

module MicroinfinityDigitalGyroscopeAndAccelerometer (DI : Device.DEVICE_INFO) (P: Port.OUTPUT_PORT) : MICROINFINITY_DIGITAL_GYROSCOPE_AND_ACCELEROMETER
(** Implementation of Microinfinity Digital Gyroscope And Accelerometer. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

