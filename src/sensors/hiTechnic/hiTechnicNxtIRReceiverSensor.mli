
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

(** Implementation of the sensor hiTechnicNxtIRReceiverSensor.
    Documentation {{:http://www.ev3dev.org/docs/sensors/hitechnic-nxt-irreceiver-sensor/} page} *)
open Device
open Port
open Sensor

module type HI_TECHNIC_NXT_I_R_RECEIVER_SENSOR = sig
  type hi_technic_nxt_i_r_receiver_sensor_commands = unit
  type hi_technic_nxt_i_r_receiver_sensor_modes = 
    | ONE_MOTOR (** Constructor for ONE_MOTOR mode. *)
    | EIGHT_MOTOR (** Constructor for EIGHT_MOTOR mode. *)
  (** Type for modes of the sensor hi_technic_nxt_i_r_receiver_sensor_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := hi_technic_nxt_i_r_receiver_sensor_commands
     and type modes    := hi_technic_nxt_i_r_receiver_sensor_modes
  
  val single_motor_control : int ufun
  (** [single_motor_control ()] returns the current value of the mode single_motor_control *)
  
  val eight_motor_control : int_tuple8 ufun
  (** [eight_motor_control ()] returns the current value of the mode eight_motor_control *)
  
end

module HiTechnicNxtIRReceiverSensor (DI : DEVICE_INFO) (P : OUTPUT_PORT)
      : HI_TECHNIC_NXT_I_R_RECEIVER_SENSOR
(** Implementation of Hi Technic Nxt I R Receiver Sensor. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

