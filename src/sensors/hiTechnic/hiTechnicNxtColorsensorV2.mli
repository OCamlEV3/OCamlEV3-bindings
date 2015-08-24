
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

(** Implementation of the sensor hiTechnicNxtColorsensorV2.
    Documentation {{:http://www.ev3dev.org/docs/sensors/hitechnic-nxt-color-sensor-v2/} page} *)
open Device
open Port
open Sensor

module type HI_TECHNIC_NXT_COLORSENSOR_V2 = sig
  
  type hi_technic_nxt_colorsensor_v2_modes = 
    | COLOR (** Constructor for COLOR mode. *)
    | RED (** Constructor for RED mode. *)
    | GREEN (** Constructor for GREEN mode. *)
    | BLUE (** Constructor for BLUE mode. *)
    | WHITE (** Constructor for WHITE mode. *)
    | NORM (** Constructor for NORM mode. *)
    | ALL (** Constructor for ALL mode. *)
    | RAW (** Constructor for RAW mode. *)
  (** Type for modes of the sensor hi_technic_nxt_colorsensor_v2_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := hi_technic_nxt_colorsensor_v2_modes
  
  val color : int ufun
  (** [color ()] returns the current value of the mode color *)
  
  val red_value : int ufun
  (** [red_value ()] returns the current value of the mode red_value *)
  
  val green_value : int ufun
  (** [green_value ()] returns the current value of the mode green_value *)
  
  val blue_value : int ufun
  (** [blue_value ()] returns the current value of the mode blue_value *)
  
  val white_value : int ufun
  (** [white_value ()] returns the current value of the mode white_value *)
  
  val normalized_values : int_tuple4 ufun
  (** [normalized_values ()] returns the current value of the mode normalized_values *)
  
  val all_values : int_tuple5 ufun
  (** [all_values ()] returns the current value of the mode all_values *)
  
  val raw_values : int_tuple4 ufun
  (** [raw_values ()] returns the current value of the mode raw_values *)
  
end

module HiTechnicNxtColorsensorV2 (DI : Device.DEVICE_INFO) (P: Port.OUTPUT_PORT) : HI_TECHNIC_NXT_COLORSENSOR_V2
(** Implementation of Hi Technic Nxt Colorsensor V2. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

