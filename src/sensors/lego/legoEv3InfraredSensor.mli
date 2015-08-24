
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

(** Implementation of the sensor legoEv3InfraredSensor.
    Documentation {{:http://www.ev3dev.org/docs/sensors/lego-ev3-infrared-sensor/} page} *)
open Device
open Port
open Sensor

module type LEGO_EV3_INFRARED_SENSOR = sig
  type lego_ev3_infrared_sensor_commands = unit
  type lego_ev3_infrared_sensor_modes = 
    | IR_PROX (** Constructor for IR_PROX mode. *)
    | IR_SEEKER (** Constructor for IR_SEEKER mode. *)
    | IR_REMOTE (** Constructor for IR_REMOTE mode. *)
    | IR_REM_A (** Constructor for IR_REM_A mode. *)
    | IR_S_ALT (** Constructor for IR_S_ALT mode. *)
    | IR_CAL (** Constructor for IR_CAL mode. *)
  (** Type for modes of the sensor lego_ev3_infrared_sensor_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := lego_ev3_infrared_sensor_commands
     and type modes    := lego_ev3_infrared_sensor_modes
  
  val proximity : int ufun
  (** [proximity ()] returns the current value of the mode proximity *)
  
  val ir_seeker : int_tuple8 ufun
  (** [ir_seeker ()] returns the current value of the mode ir_seeker *)
  
  val ir_remote_control : int_tuple4 ufun
  (** [ir_remote_control ()] returns the current value of the mode ir_remote_control *)
  
  val ir_remote_control_a : int ufun
  (** [ir_remote_control_a ()] returns the current value of the mode ir_remote_control_a *)
  
  val alternate_ir_seeker : int_tuple4 ufun
  (** [alternate_ir_seeker ()] returns the current value of the mode alternate_ir_seeker *)
  
  val calibration : int_tuple2 ufun
  (** [calibration ()] returns the current value of the mode calibration *)
  
end

module LegoEv3InfraredSensor (DI : DEVICE_INFO) (P : OUTPUT_PORT)
      : LEGO_EV3_INFRARED_SENSOR
(** Implementation of Lego Ev3 Infrared Sensor. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

