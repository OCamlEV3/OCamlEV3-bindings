
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

(** Implementation of the sensor mindsensorsChannelServoMotor.
    Documentation {{:http://www.ev3dev.org/docs/sensors/mindsensors.com-8-channel-servo-controller/} page} *)
open Device
open Port
open Sensor

module type MINDSENSORS_CHANNEL_SERVO_MOTOR = sig
  
  type mindsensors_channel_servo_motor_modes = 
    | VTHREE (** Constructor for VTHREE mode. *)
    | OLD (** Constructor for OLD mode. *)
  (** Type for modes of the sensor mindsensors_channel_servo_motor_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := mindsensors_channel_servo_motor_modes
  
  val ev3_compatible_value : int ufun
  (** [ev3_compatible_value ()] returns the current value of the mode ev3_compatible_value *)
  
  val old_compatible_value : int ufun
  (** [old_compatible_value ()] returns the current value of the mode old_compatible_value *)
  
end

module MindsensorsChannelServoMotor (DI : Device.DEVICE_INFO) (P: Port.OUTPUT_PORT) : MINDSENSORS_CHANNEL_SERVO_MOTOR
(** Implementation of Mindsensors Channel Servo Motor. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

