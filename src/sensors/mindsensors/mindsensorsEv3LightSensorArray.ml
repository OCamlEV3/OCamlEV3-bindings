
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

module type MINDSENSORS_EV3_LIGHT_SENSOR_ARRAY = sig
  type mindsensors_ev3_light_sensor_array_commands = 
    | CAL_WHITE
    | CAL_BLACK
    | SLEEP
    | WAKE
    | SIXZEROHZ
    | FIVEZEROHZ
    | UNIVERSAL
  
  type mindsensors_ev3_light_sensor_array_modes = 
    | CAL
    | RAW
  
  include Sensor.AbstractSensor
    with type commands := mindsensors_ev3_light_sensor_array_commands
     and type modes    := mindsensors_ev3_light_sensor_array_modes
  
  val calibrated_values : int_tuple3 ufun
  val raw_values : int_tuple3 ufun
end

module MindsensorsEv3LightSensorArray (DI : DEVICE_INFO)
    (P : OUTPUT_PORT) = struct
  type mindsensors_ev3_light_sensor_array_commands = 
    | CAL_WHITE
    | CAL_BLACK
    | SLEEP
    | WAKE
    | SIXZEROHZ
    | FIVEZEROHZ
    | UNIVERSAL
  
  type mindsensors_ev3_light_sensor_array_modes = 
    | CAL
    | RAW
  
  module MindsensorsEv3LightSensorArrayCommands = struct
    type commands = mindsensors_ev3_light_sensor_array_commands
    let string_of_commands = function
      | CAL_WHITE -> "cal-white"
      | CAL_BLACK -> "cal-black"
      | SLEEP -> "sleep"
      | WAKE -> "wake"
      | SIXZEROHZ -> "60hz"
      | FIVEZEROHZ -> "50hz"
      | UNIVERSAL -> "universal"
    
  end
  
  module MindsensorsEv3LightSensorArrayModes = struct
    type modes = mindsensors_ev3_light_sensor_array_modes
    let modes_of_string = function
      | "cal" -> CAL
      | "raw" -> RAW
      | _ -> assert false
    
    let string_of_modes = function
      | CAL -> "cal"
      | RAW -> "raw"
    
    let default_mode = CAL
  end
  
  module MindsensorsEv3LightSensorArrayPathFinder = Path_finder.Make(struct
      let prefix = "/sys/class/lego-sensor"
      let conditions = [
        ("name", "ms-light-array");
        ("port", string_of_output_port P.output_port)
      ]
    end)
  
  include Make_abstract_sensor(MindsensorsEv3LightSensorArrayCommands)
      (MindsensorsEv3LightSensorArrayModes)(DI)
      (MindsensorsEv3LightSensorArrayPathFinder)
  
  let calibrated_values = checked_read read3 CAL
  let raw_values = checked_read read3 RAW
end


(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

