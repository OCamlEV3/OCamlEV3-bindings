
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

module type LEGO_NXT_LIGHT_SENSOR = sig
  type lego_nxt_light_sensor_commands = unit
  type lego_nxt_light_sensor_modes = 
    | REFLECT
    | AMBIANT
  
  include Sensor.AbstractSensor
    with type commands := lego_nxt_light_sensor_commands
     and type modes    := lego_nxt_light_sensor_modes
  
  val reflected_light : int ufun
  val ambiant_light : int ufun
end

module LegoNxtLightSensor (DI : DEVICE_INFO)
    (P : OUTPUT_PORT) = struct
  type lego_nxt_light_sensor_commands = unit
  type lego_nxt_light_sensor_modes = 
    | REFLECT
    | AMBIANT
  
  module LegoNxtLightSensorCommands = struct
    type commands = lego_nxt_light_sensor_commands
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module LegoNxtLightSensorModes = struct
    type modes = lego_nxt_light_sensor_modes
    let modes_of_string = function
      | "reflect" -> REFLECT
      | "ambiant" -> AMBIANT
      | _ -> assert false
    
    let string_of_modes = function
      | REFLECT -> "reflect"
      | AMBIANT -> "ambiant"
    
    let default_mode = REFLECT
  end
  
  module LegoNxtLightSensorPathFinder = Path_finder.Make(struct
      let prefix = "/sys/class/lego-sensor"
      let conditions = [
        ("name", "lego-nxt-light");
        ("port", string_of_output_port P.output_port)
      ]
    end)
  
  include Make_abstract_sensor(LegoNxtLightSensorCommands)
      (LegoNxtLightSensorModes)(DI)(LegoNxtLightSensorPathFinder)
  
  let reflected_light = checked_read read1 REFLECT
  let ambiant_light = checked_read read1 AMBIANT
end


(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

