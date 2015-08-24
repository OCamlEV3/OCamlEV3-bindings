
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

module type LEGO_NXT_TOUCH_SENSOR = sig
  type lego_nxt_touch_sensor_commands = unit
  type lego_nxt_touch_sensor_modes = 
    | TOUCH
  
  include Sensor.AbstractSensor
    with type commands := lego_nxt_touch_sensor_commands
     and type modes    := lego_nxt_touch_sensor_modes
  
  val touch_state : int ufun
end

module LegoNxtTouchSensor (DI : DEVICE_INFO)
    (P : OUTPUT_PORT) = struct
  type lego_nxt_touch_sensor_commands = unit
  type lego_nxt_touch_sensor_modes = 
    | TOUCH
  
  module LegoNxtTouchSensorCommands = struct
    type commands = lego_nxt_touch_sensor_commands
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module LegoNxtTouchSensorModes = struct
    type modes = lego_nxt_touch_sensor_modes
    let modes_of_string = function
      | "touch" -> TOUCH
      | _ -> assert false
    
    let string_of_modes = function
      | TOUCH -> "touch"
    
    let default_mode = TOUCH
  end
  
  module LegoNxtTouchSensorPathFinder = Path_finder.Make(struct
      let prefix = "/sys/class/lego-sensor"
      let conditions = [
        ("name", "lego-nxt-touch");
        ("port", string_of_output_port P.output_port)
      ]
    end)
  
  include Make_abstract_sensor(LegoNxtTouchSensorCommands)
      (LegoNxtTouchSensorModes)(DI)(LegoNxtTouchSensorPathFinder)
  
  let touch_state = checked_read read1 TOUCH
end


(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

