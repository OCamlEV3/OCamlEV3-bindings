
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

(** Implementation of the sensor mindsensorsEv3LightSensorArray.
    Documentation {{:http://www.ev3dev.org/docs/sensors/mindsensors.com-light-sensor-array/} page} *)
open Device
open Port
open Sensor

module type MINDSENSORS_EV3_LIGHT_SENSOR_ARRAY = sig
  type mindsensors_ev3_light_sensor_array_commands = 
    | CAL_WHITE (** Constructor for CAL_WHITE mode. *)
    | CAL_BLACK (** Constructor for CAL_BLACK mode. *)
    | SLEEP (** Constructor for SLEEP mode. *)
    | WAKE (** Constructor for WAKE mode. *)
    | SIXZEROHZ (** Constructor for SIXZEROHZ mode. *)
    | FIVEZEROHZ (** Constructor for FIVEZEROHZ mode. *)
    | UNIVERSAL (** Constructor for UNIVERSAL mode. *)
  (** Type for commands of the sensor mindsensors_ev3_light_sensor_array_commands. *)
  
  type mindsensors_ev3_light_sensor_array_modes = 
    | CAL (** Constructor for CAL mode. *)
    | RAW (** Constructor for RAW mode. *)
  (** Type for modes of the sensor mindsensors_ev3_light_sensor_array_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := mindsensors_ev3_light_sensor_array_commands
     and type modes    := mindsensors_ev3_light_sensor_array_modes
  
  val calibrated_values : int_tuple3 ufun
  (** [calibrated_values ()] returns the current value of the mode calibrated_values *)
  
  val raw_values : int_tuple3 ufun
  (** [raw_values ()] returns the current value of the mode raw_values *)
  
end

module MindsensorsEv3LightSensorArray (DI : DEVICE_INFO) (P : OUTPUT_PORT)
      : MINDSENSORS_EV3_LIGHT_SENSOR_ARRAY
(** Implementation of Mindsensors Ev3 Light Sensor Array. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

