
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

(** Implementation of the sensor hiTechnicNxtSuperproPrototypeBoard.
    Documentation {{:http://www.ev3dev.org/docs/sensors/hitechnic-nxt-superpro-prototype-board/} page} *)
open Device
open Port
open Sensor

module type HI_TECHNIC_NXT_SUPERPRO_PROTOTYPE_BOARD = sig
  
  type hi_technic_nxt_superpro_prototype_board_modes = 
    | AIN (** Constructor for AIN mode. *)
    | DIN (** Constructor for DIN mode. *)
    | DOUT (** Constructor for DOUT mode. *)
    | DCTRL (** Constructor for DCTRL mode. *)
    | STROBE (** Constructor for STROBE mode. *)
    | LED (** Constructor for LED mode. *)
    | AOUT_ZERO (** Constructor for AOUT_ZERO mode. *)
    | AOUT_ONE (** Constructor for AOUT_ONE mode. *)
  (** Type for modes of the sensor hi_technic_nxt_superpro_prototype_board_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := hi_technic_nxt_superpro_prototype_board_modes
  
  val analog_inputs : int_tuple4 ufun
  (** [analog_inputs ()] returns the current value of the mode analog_inputs *)
  
  val digital_inputs : int ufun
  (** [digital_inputs ()] returns the current value of the mode digital_inputs *)
  
  val digital_outputs : int ufun
  (** [digital_outputs ()] returns the current value of the mode digital_outputs *)
  
  val digital_controls : int ufun
  (** [digital_controls ()] returns the current value of the mode digital_controls *)
  
  val strobe_output : int ufun
  (** [strobe_output ()] returns the current value of the mode strobe_output *)
  
  val led_control : int ufun
  (** [led_control ()] returns the current value of the mode led_control *)
  
  val analog_output_o0 : int_tuple5 ufun
  (** [analog_output_o0 ()] returns the current value of the mode analog_output_o0 *)
  
  val analog_output_o1 : int_tuple5 ufun
  (** [analog_output_o1 ()] returns the current value of the mode analog_output_o1 *)
  
end

module HiTechnicNxtSuperproPrototypeBoard (DI : Device.DEVICE_INFO) (P: Port.OUTPUT_PORT) : HI_TECHNIC_NXT_SUPERPRO_PROTOTYPE_BOARD
(** Implementation of Hi Technic Nxt Superpro Prototype Board. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

