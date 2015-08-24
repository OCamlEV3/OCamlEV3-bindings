
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

open Device
open Port
open Sensor

module type MINDSENSORS_GLIDE_WHEEL_A_S = sig
  
  type mindsensors_glide_wheel_a_s_modes = 
    | ANGLE
    | ANGLETWO
    | SPEED
    | ALL
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := mindsensors_glide_wheel_a_s_modes
  
  val angle : int ufun
  val high_precision_angle : int ufun
  val speed : int ufun
  val all_values : int_tuple3 ufun
end


module MindsensorsGlideWheelAS (DI : DEVICE_INFO)
  (P : OUTPUT_PORT) = struct
  type mindsensors_glide_wheel_a_s_modes = 
    | ANGLE
    | ANGLETWO
    | SPEED
    | ALL
  
  
  module MindsensorsGlideWheelASCommands = struct
    type commands = unit
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module MindsensorsGlideWheelASModes = struct
    type modes = mindsensors_glide_wheel_a_s_modes
    let modes_of_string = function
      | "angle" -> ANGLE
      | "angle2" -> ANGLETWO
      | "speed" -> SPEED
      | "all" -> ALL
      | _ -> assert false
    
    let string_of_modes = function
      | ANGLE -> "angle"
      | ANGLETWO -> "angle2"
      | SPEED -> "speed"
      | ALL -> "all"
    let default_mode = ANGLE
  end
  
  
  module MindsensorsGlideWheelASPathFinder = Path_finder.Make(struct
    let prefix = "/sys/class/lego-sensor"
    let conditions = [
      ("name", "ms-angle");
      ("port", string_of_output_port P.output_port)
    ]
  end)
  
  include Make_abstract_sensor(MindsensorsGlideWheelASCommands)
    (MindsensorsGlideWheelASModes)(DI)
    (MindsensorsGlideWheelASPathFinder)
    
    let angle = checked_read read1 ANGLE
    let high_precision_angle = checked_read read1 ANGLETWO
    let speed = checked_read read1 SPEED
    let all_values = checked_read read3 ALL
  end
  
  
(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

