
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

(** Implementation of the sensor legoNxtUltrasonicSensor.
    Documentation {{:http://www.ev3dev.org/docs/sensors/lego-nxt-ultrasonic-sensor/} page} *)
open Device
open Port
open Sensor

module type LEGO_NXT_ULTRASONIC_SENSOR = sig
  
  type lego_nxt_ultrasonic_sensor_modes = 
    | US_DIST_CM (** Constructor for US_DIST_CM mode. *)
    | US_DIST_IN (** Constructor for US_DIST_IN mode. *)
    | US_SI_CM (** Constructor for US_SI_CM mode. *)
    | US_SI_IN (** Constructor for US_SI_IN mode. *)
    | LISTEN (** Constructor for LISTEN mode. *)
  (** Type for modes of the sensor lego_nxt_ultrasonic_sensor_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := lego_nxt_ultrasonic_sensor_modes
  
  val continuous_dist_cm : int ufun
  (** [continuous_dist_cm ()] returns the current value of the mode continuous_dist_cm *)
  
  val continuous_dist_in : int ufun
  (** [continuous_dist_in ()] returns the current value of the mode continuous_dist_in *)
  
  val single_dist_cm : int ufun
  (** [single_dist_cm ()] returns the current value of the mode single_dist_cm *)
  
  val single_dist_in : int ufun
  (** [single_dist_in ()] returns the current value of the mode single_dist_in *)
  
  val listen : int ufun
  (** [listen ()] returns the current value of the mode listen *)
  
end

module LegoNxtUltrasonicSensor (DI : Device.DEVICE_INFO) (P: Port.OUTPUT_PORT) : LEGO_NXT_ULTRASONIC_SENSOR
(** Implementation of Lego Nxt Ultrasonic Sensor. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

