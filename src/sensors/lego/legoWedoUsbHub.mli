
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

(** Implementation of the sensor legoWedoUsbHub.
    Documentation {{:http://www.ev3dev.org/docs/sensors/lego-wedo-usb-hub/} page} *)
open Device
open Port
open Sensor

module type LEGO_WEDO_USB_HUB = sig
  type lego_wedo_usb_hub_commands = 
    | OUT_OFF (** Constructor for OUT_OFF mode. *)
    | OUT_ON (** Constructor for OUT_ON mode. *)
    | CLEAR_ERR (** Constructor for CLEAR_ERR mode. *)
  (** Type for commands of the sensor lego_wedo_usb_hub_commands. *)
  
  type lego_wedo_usb_hub_modes = 
    | HUB (** Constructor for HUB mode. *)
  (** Type for modes of the sensor lego_wedo_usb_hub_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := lego_wedo_usb_hub_commands
     and type modes    := lego_wedo_usb_hub_modes
  
  val hub_status : int_tuple2 ufun
  (** [hub_status ()] returns the current value of the mode hub_status *)
  
end

module LegoWedoUsbHub (DI : DEVICE_INFO) (P : OUTPUT_PORT)
      : LEGO_WEDO_USB_HUB
(** Implementation of Lego Wedo Usb Hub. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

