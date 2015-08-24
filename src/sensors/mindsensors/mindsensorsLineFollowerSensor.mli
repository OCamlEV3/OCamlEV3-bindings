
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

(** Implementation of the sensor mindsensorsLineFollowerSensor.
    Documentation {{:http://www.ev3dev.org/docs/sensors/mindsensors.com-line-follower-sensor/} page} *)
open Device
open Port
open Sensor

module type MINDSENSORS_LINE_FOLLOWER_SENSOR = sig
  type mindsensors_line_follower_sensor_commands = 
    | CAL_WHITE (** Constructor for CAL_WHITE mode. *)
    | CAL_BLACK (** Constructor for CAL_BLACK mode. *)
    | SLEEP (** Constructor for SLEEP mode. *)
    | WAKE (** Constructor for WAKE mode. *)
    | INV_COL (** Constructor for INV_COL mode. *)
    | RST_COL (** Constructor for RST_COL mode. *)
    | SNAP (** Constructor for SNAP mode. *)
    | SIXZEROHZ (** Constructor for SIXZEROHZ mode. *)
    | FIVEZEROHZ (** Constructor for FIVEZEROHZ mode. *)
    | UNIVERSAL (** Constructor for UNIVERSAL mode. *)
  (** Type for commands of the sensor mindsensors_line_follower_sensor_commands. *)
  
  type mindsensors_line_follower_sensor_modes = 
    | PID (** Constructor for PID mode. *)
    | PID_ALL (** Constructor for PID_ALL mode. *)
    | CAL (** Constructor for CAL mode. *)
    | RAW (** Constructor for RAW mode. *)
  (** Type for modes of the sensor mindsensors_line_follower_sensor_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := mindsensors_line_follower_sensor_commands
     and type modes    := mindsensors_line_follower_sensor_modes
  
  val line_follower : int ufun
  (** [line_follower ()] returns the current value of the mode line_follower *)
  
  val line_follower_all_values : int_tuple3 ufun
  (** [line_follower_all_values ()] returns the current value of the mode line_follower_all_values *)
  
  val calibrated_values : int_tuple8 ufun
  (** [calibrated_values ()] returns the current value of the mode calibrated_values *)
  
  val raw_values : int_tuple8 ufun
  (** [raw_values ()] returns the current value of the mode raw_values *)
  
end

module MindsensorsLineFollowerSensor (DI : DEVICE_INFO) (P : OUTPUT_PORT)
      : MINDSENSORS_LINE_FOLLOWER_SENSOR
(** Implementation of Mindsensors Line Follower Sensor. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

