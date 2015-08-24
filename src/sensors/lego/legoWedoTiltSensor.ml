
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

module type LEGO_WEDO_TILT_SENSOR = sig
  
  type lego_wedo_tilt_sensor_modes = 
    | TILT
    | TILT_AXIS
    | RAW
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := lego_wedo_tilt_sensor_modes
  
  val tilt_status : int ufun
  val tilt_status_axis : int_tuple3 ufun
  val tilt_raw_analog_value : int ufun
end


module LegoWedoTiltSensor (DI : DEVICE_INFO)
  (P : OUTPUT_PORT) = struct
  type lego_wedo_tilt_sensor_modes = 
    | TILT
    | TILT_AXIS
    | RAW
  
  
  module LegoWedoTiltSensorCommands = struct
    type commands = unit
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module LegoWedoTiltSensorModes = struct
    type modes = lego_wedo_tilt_sensor_modes
    let modes_of_string = function
      | "tilt" -> TILT
      | "tilt-axis" -> TILT_AXIS
      | "raw" -> RAW
      | _ -> assert false
    
    let string_of_modes = function
      | TILT -> "tilt"
      | TILT_AXIS -> "tilt-axis"
      | RAW -> "raw"
    let default_mode = TILT
  end
  
  
  module LegoWedoTiltSensorPathFinder = Path_finder.Make(struct
    let prefix = "/sys/class/lego-sensor"
    let conditions = [
      ("name", "wedo-tilt");
      ("port", string_of_output_port P.output_port)
    ]
  end)
  
  include Make_abstract_sensor(LegoWedoTiltSensorCommands)
    (LegoWedoTiltSensorModes)(DI)
    (LegoWedoTiltSensorPathFinder)
    
    let tilt_status = checked_read read1 TILT
    let tilt_status_axis = checked_read read3 TILT_AXIS
    let tilt_raw_analog_value = checked_read read1 RAW
  end
  
  
(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

