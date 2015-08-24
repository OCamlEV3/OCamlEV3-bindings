
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

module type MINDSENSORS_LINE_FOLLOWER_SENSOR = sig
  
  type mindsensors_line_follower_sensor_modes = 
    | PID
    | PID_ALL
    | CAL
    | RAW
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := mindsensors_line_follower_sensor_modes
  
  val line_follower : int ufun
  val line_follower_all_values : int_tuple3 ufun
  val calibrated_values : int_tuple8 ufun
  val raw_values : int_tuple8 ufun
end


module MindsensorsLineFollowerSensor (DI : DEVICE_INFO)
  (P : OUTPUT_PORT) = struct
  type mindsensors_line_follower_sensor_modes = 
    | PID
    | PID_ALL
    | CAL
    | RAW
  
  
  module MindsensorsLineFollowerSensorCommands = struct
    type commands = unit
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module MindsensorsLineFollowerSensorModes = struct
    type modes = mindsensors_line_follower_sensor_modes
    let modes_of_string = function
      | "pid" -> PID
      | "pid-all" -> PID_ALL
      | "cal" -> CAL
      | "raw" -> RAW
      | _ -> assert false
    
    let string_of_modes = function
      | PID -> "pid"
      | PID_ALL -> "pid-all"
      | CAL -> "cal"
      | RAW -> "raw"
    let default_mode = PID
  end
  
  
  module MindsensorsLineFollowerSensorPathFinder = Path_finder.Make(struct
    let prefix = "/sys/class/lego-sensor"
    let conditions = [
      ("name", "ms-line-leader");
      ("port", string_of_output_port P.output_port)
    ]
  end)
  
  include Make_abstract_sensor(MindsensorsLineFollowerSensorCommands)
    (MindsensorsLineFollowerSensorModes)(DI)
    (MindsensorsLineFollowerSensorPathFinder)
    
    let line_follower = checked_read read1 PID
    let line_follower_all_values = checked_read read3 PID_ALL
    let calibrated_values = checked_read read8 CAL
    let raw_values = checked_read read8 RAW
  end
  
  
(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

