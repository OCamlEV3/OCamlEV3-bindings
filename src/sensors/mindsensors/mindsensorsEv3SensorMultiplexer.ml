
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

module type MINDSENSORS_EV3_SENSOR_MULTIPLEXER = sig
  type mindsensors_ev3_sensor_multiplexer_commands = unit
  type mindsensors_ev3_sensor_multiplexer_modes = 
    | MUX
  
  include Sensor.AbstractSensor
    with type commands := mindsensors_ev3_sensor_multiplexer_commands
     and type modes    := mindsensors_ev3_sensor_multiplexer_modes
  
  val sensor_multiplexer : int ufun
end

module MindsensorsEv3SensorMultiplexer (DI : DEVICE_INFO)
    (P : OUTPUT_PORT) = struct
  type mindsensors_ev3_sensor_multiplexer_commands = unit
  type mindsensors_ev3_sensor_multiplexer_modes = 
    | MUX
  
  module MindsensorsEv3SensorMultiplexerCommands = struct
    type commands = mindsensors_ev3_sensor_multiplexer_commands
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module MindsensorsEv3SensorMultiplexerModes = struct
    type modes = mindsensors_ev3_sensor_multiplexer_modes
    let modes_of_string = function
      | "mux" -> MUX
      | _ -> assert false
    
    let string_of_modes = function
      | MUX -> "mux"
    
    let default_mode = MUX
  end
  
  module MindsensorsEv3SensorMultiplexerPathFinder = Path_finder.Make(struct
      let prefix = "/sys/class/lego-sensor"
      let conditions = [
        ("name", "ms-ev3-smux");
        ("port", string_of_output_port P.output_port)
      ]
    end)
  
  include Make_abstract_sensor(MindsensorsEv3SensorMultiplexerCommands)
      (MindsensorsEv3SensorMultiplexerModes)(DI)
      (MindsensorsEv3SensorMultiplexerPathFinder)
  
  let sensor_multiplexer = checked_read read1 MUX
end


(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

