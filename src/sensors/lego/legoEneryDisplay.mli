
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

(** Implementation of the sensor legoEneryDisplay.
    Documentation {{:http://www.ev3dev.org/docs/sensors/lego-energy-display/} page} *)
open Device
open Port
open Sensor

module type LEGO_ENERY_DISPLAY = sig
  
  type lego_enery_display_modes = 
    | IN_VOLT (** Constructor for IN_VOLT mode. *)
    | IN_AMP (** Constructor for IN_AMP mode. *)
    | OUT_VOLT (** Constructor for OUT_VOLT mode. *)
    | OUT_AMP (** Constructor for OUT_AMP mode. *)
    | JOUL (** Constructor for JOUL mode. *)
    | IN_WATT (** Constructor for IN_WATT mode. *)
    | OUT_WATT (** Constructor for OUT_WATT mode. *)
    | ALL (** Constructor for ALL mode. *)
  (** Type for modes of the sensor lego_enery_display_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := lego_enery_display_modes
  
  val input_voltage : int ufun
  (** [input_voltage ()] returns the current value of the mode input_voltage *)
  
  val input_current : int ufun
  (** [input_current ()] returns the current value of the mode input_current *)
  
  val output_voltage : int ufun
  (** [output_voltage ()] returns the current value of the mode output_voltage *)
  
  val output_current : int ufun
  (** [output_current ()] returns the current value of the mode output_current *)
  
  val energy : int ufun
  (** [energy ()] returns the current value of the mode energy *)
  
  val input_power : int ufun
  (** [input_power ()] returns the current value of the mode input_power *)
  
  val output_power : int ufun
  (** [output_power ()] returns the current value of the mode output_power *)
  
  val energy_all_values : int_tuple7 ufun
  (** [energy_all_values ()] returns the current value of the mode energy_all_values *)
  
end

module LegoEneryDisplay (DI : Device.DEVICE_INFO) (P: Port.OUTPUT_PORT) : LEGO_ENERY_DISPLAY
(** Implementation of Lego Enery Display. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

