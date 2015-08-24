
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

(** Implementation of the sensor mindsensorsGlideWheelAS.
    Documentation {{:http://www.ev3dev.org/docs/sensors/mindsensors.com-glidewheel-as/} page} *)
open Device
open Port
open Sensor

module type MINDSENSORS_GLIDE_WHEEL_A_S = sig
  type mindsensors_glide_wheel_a_s_commands = 
    | RESET (** Constructor for RESET mode. *)
  (** Type for commands of the sensor mindsensors_glide_wheel_a_s_commands. *)
  
  type mindsensors_glide_wheel_a_s_modes = 
    | ANGLE (** Constructor for ANGLE mode. *)
    | ANGLETWO (** Constructor for ANGLETWO mode. *)
    | SPEED (** Constructor for SPEED mode. *)
    | ALL (** Constructor for ALL mode. *)
  (** Type for modes of the sensor mindsensors_glide_wheel_a_s_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := mindsensors_glide_wheel_a_s_commands
     and type modes    := mindsensors_glide_wheel_a_s_modes
  
  val angle : int ufun
  (** [angle ()] returns the current value of the mode angle *)
  
  val high_precision_angle : int ufun
  (** [high_precision_angle ()] returns the current value of the mode high_precision_angle *)
  
  val speed : int ufun
  (** [speed ()] returns the current value of the mode speed *)
  
  val all_values : int_tuple3 ufun
  (** [all_values ()] returns the current value of the mode all_values *)
  
end

module MindsensorsGlideWheelAS (DI : DEVICE_INFO) (P : OUTPUT_PORT)
      : MINDSENSORS_GLIDE_WHEEL_A_S
(** Implementation of Mindsensors Glide Wheel A S. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

