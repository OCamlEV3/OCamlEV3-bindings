
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

module type MINDSENSORS_TOUCH_SENSOR_MULTIPLEXER = sig
  type mindsensors_touch_sensor_multiplexer_commands = unit
  type mindsensors_touch_sensor_multiplexer_modes = 
    | TOUCH_MUX
  
  include Sensor.AbstractSensor
    with type commands := mindsensors_touch_sensor_multiplexer_commands
     and type modes    := mindsensors_touch_sensor_multiplexer_modes
  
  val touch_sensors : int_tuple3 ufun
end

module MindsensorsTouchSensorMultiplexer (DI : DEVICE_INFO)
    (P : OUTPUT_PORT) = struct
  type mindsensors_touch_sensor_multiplexer_commands = unit
  type mindsensors_touch_sensor_multiplexer_modes = 
    | TOUCH_MUX
  
  module MindsensorsTouchSensorMultiplexerCommands = struct
    type commands = mindsensors_touch_sensor_multiplexer_commands
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module MindsensorsTouchSensorMultiplexerModes = struct
    type modes = mindsensors_touch_sensor_multiplexer_modes
    let modes_of_string = function
      | "touch-mux" -> TOUCH_MUX
      | _ -> assert false
    
    let string_of_modes = function
      | TOUCH_MUX -> "touch-mux"
    
    let default_mode = TOUCH_MUX
  end
  
  module MindsensorsTouchSensorMultiplexerPathFinder = Path_finder.Make(struct
      let prefix = "/sys/class/lego-sensor"
      let conditions = [
        ("name", "ms-nxt-touch-mux");
        ("port", string_of_output_port P.output_port)
      ]
    end)
  
  include Make_abstract_sensor(MindsensorsTouchSensorMultiplexerCommands)
      (MindsensorsTouchSensorMultiplexerModes)(DI)
      (MindsensorsTouchSensorMultiplexerPathFinder)
  
  let touch_sensors = checked_read read3 TOUCH_MUX
end


(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

