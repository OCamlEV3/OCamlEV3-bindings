
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

(** Implementation of the sensor mindsensorsMultiplexerNxtEv3Motor.
    Documentation {{:http://www.ev3dev.org/docs/sensors/mindsensors.com-multiplexer-for-nxt-ev3-motors/} page} *)
open Device
open Port
open Sensor

module type MINDSENSORS_MULTIPLEXER_NXT_EV3_MOTOR = sig
  type mindsensors_multiplexer_nxt_ev3_motor_commands = unit
  type mindsensors_multiplexer_nxt_ev3_motor_modes = 
    | STATUS (** Constructor for STATUS mode. *)
    | STATUS_OLD (** Constructor for STATUS_OLD mode. *)
  (** Type for modes of the sensor mindsensors_multiplexer_nxt_ev3_motor_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := mindsensors_multiplexer_nxt_ev3_motor_commands
     and type modes    := mindsensors_multiplexer_nxt_ev3_motor_modes
  
  val status : int ufun
  (** [status ()] returns the current value of the mode status *)
  
  val old_firmware_status : int ufun
  (** [old_firmware_status ()] returns the current value of the mode old_firmware_status *)
  
end

module MindsensorsMultiplexerNxtEv3Motor (DI : DEVICE_INFO) (P : OUTPUT_PORT)
      : MINDSENSORS_MULTIPLEXER_NXT_EV3_MOTOR
(** Implementation of Mindsensors Multiplexer Nxt Ev3 Motor. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

