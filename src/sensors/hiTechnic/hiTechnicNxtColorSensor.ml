
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

module type HI_TECHNIC_NXT_COLOR_SENSOR = sig
  
  type hi_technic_nxt_color_sensor_modes = 
    | COLOR
    | RED
    | GREEN
    | BLUE
    | RAW
    | NORM
    | ALL
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := hi_technic_nxt_color_sensor_modes
  
  val color : int ufun
  val red_value : int ufun
  val green_value : int ufun
  val blue_value : int ufun
  val raw_values : int_tuple3 ufun
  val normalized_values : int_tuple4 ufun
  val all_values : int_tuple4 ufun
end


module HiTechnicNxtColorSensor (DI : DEVICE_INFO)
  (P : OUTPUT_PORT) = struct
  type hi_technic_nxt_color_sensor_modes = 
    | COLOR
    | RED
    | GREEN
    | BLUE
    | RAW
    | NORM
    | ALL
  
  
  module HiTechnicNxtColorSensorCommands = struct
    type commands = unit
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module HiTechnicNxtColorSensorModes = struct
    type modes = hi_technic_nxt_color_sensor_modes
    let modes_of_string = function
      | "color" -> COLOR
      | "red" -> RED
      | "green" -> GREEN
      | "blue" -> BLUE
      | "raw" -> RAW
      | "norm" -> NORM
      | "all" -> ALL
      | _ -> assert false
    
    let string_of_modes = function
      | COLOR -> "color"
      | RED -> "red"
      | GREEN -> "green"
      | BLUE -> "blue"
      | RAW -> "raw"
      | NORM -> "norm"
      | ALL -> "all"
    let default_mode = COLOR
  end
  
  
  module HiTechnicNxtColorSensorPathFinder = Path_finder.Make(struct
    let prefix = "/sys/class/lego-sensor"
    let conditions = [
      ("name", "ht-nxt-color");
      ("port", string_of_output_port P.output_port)
    ]
  end)
  
  include Make_abstract_sensor(HiTechnicNxtColorSensorCommands)
    (HiTechnicNxtColorSensorModes)(DI)
    (HiTechnicNxtColorSensorPathFinder)
    
    let color = checked_read read1 COLOR
    let red_value = checked_read read1 RED
    let green_value = checked_read read1 GREEN
    let blue_value = checked_read read1 BLUE
    let raw_values = checked_read read3 RAW
    let normalized_values = checked_read read4 NORM
    let all_values = checked_read read4 ALL
  end
  
  
(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

