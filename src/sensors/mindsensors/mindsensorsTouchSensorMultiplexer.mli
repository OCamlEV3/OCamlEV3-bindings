
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

(** Implementation of the sensor mindsensorsTouchSensorMultiplexer.
    Documentation {{:http://www.ev3dev.org/docs/sensors/mindsensors.com-touch-sensor-multiplexer-for-nxt-ev3/} page} *)
open Device
open Port
open Sensor

module type MINDSENSORS_TOUCH_SENSOR_MULTIPLEXER = sig
  type mindsensors_touch_sensor_multiplexer_commands = unit
  type mindsensors_touch_sensor_multiplexer_modes = 
    | TOUCH_MUX (** Constructor for TOUCH_MUX mode. *)
  (** Type for modes of the sensor mindsensors_touch_sensor_multiplexer_modes. *)
  
  include Sensor.AbstractSensor
    with type commands := mindsensors_touch_sensor_multiplexer_commands
     and type modes    := mindsensors_touch_sensor_multiplexer_modes
  
  val touch_sensors : int_tuple3 ufun
  (** [touch_sensors ()] returns the current value of the mode touch_sensors *)
  
end

module MindsensorsTouchSensorMultiplexer (DI : DEVICE_INFO) (P : OUTPUT_PORT)
      : MINDSENSORS_TOUCH_SENSOR_MULTIPLEXER
(** Implementation of Mindsensors Touch Sensor Multiplexer. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

