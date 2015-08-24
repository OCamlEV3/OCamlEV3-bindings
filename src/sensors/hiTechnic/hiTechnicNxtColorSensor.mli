
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

(** Implementation of the sensor hiTechnicNxtColorSensor.
    Documentation {{:http://www.ev3dev.org/docs/sensors/hitechnic-nxt-color-sensor/} page} *)
open Device
open Port
open Sensor

module type HI_TECHNIC_NXT_COLOR_SENSOR = sig
  type hi_technic_nxt_color_sensor_commands = 
    | RESET (** Constructor for RESET mode. *)
    | CAL (** Constructor for CAL mode. *)
  (** Type for commands of the sensor hi_technic_nxt_color_sensor_commands. *)
  
  type hi_technic_nxt_color_sensor_modes = 
    | COLOR (** Constructor for COLOR mode. *)
    | RED (** Constructor for RED mode. *)
    | GREEN (** Constructor for GREEN mode. *)
    | BLUE (** Constructor for BLUE mode. *)
    | RAW (** Constructor for RAW mode. *)
    | NORM (** Constructor for NORM mode. *)
    | ALL (** Constructor for ALL mode. *)
  (** Type for modes of the sensor hi_technic_nxt_color_sensor_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := hi_technic_nxt_color_sensor_commands
     and type modes    := hi_technic_nxt_color_sensor_modes
  
  val color : int ufun
  (** [color ()] returns the current value of the mode color *)
  
  val red_value : int ufun
  (** [red_value ()] returns the current value of the mode red_value *)
  
  val green_value : int ufun
  (** [green_value ()] returns the current value of the mode green_value *)
  
  val blue_value : int ufun
  (** [blue_value ()] returns the current value of the mode blue_value *)
  
  val raw_values : int_tuple3 ufun
  (** [raw_values ()] returns the current value of the mode raw_values *)
  
  val normalized_values : int_tuple4 ufun
  (** [normalized_values ()] returns the current value of the mode normalized_values *)
  
  val all_values : int_tuple4 ufun
  (** [all_values ()] returns the current value of the mode all_values *)
  
end

module HiTechnicNxtColorSensor (DI : DEVICE_INFO) (P : OUTPUT_PORT)
      : HI_TECHNIC_NXT_COLOR_SENSOR
(** Implementation of Hi Technic Nxt Color Sensor. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

