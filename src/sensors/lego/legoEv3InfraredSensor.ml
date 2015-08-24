
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

module type LEGO_EV3_INFRARED_SENSOR = sig
  
  type lego_ev3_infrared_sensor_modes = 
    | IR_PROX
    | IR_SEEKER
    | IR_REMOTE
    | IR_REM_A
    | IR_S_ALT
    | IR_CAL
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := lego_ev3_infrared_sensor_modes
  
  val proximity : int ufun
  val ir_seeker : int_tuple8 ufun
  val ir_remote_control : int_tuple4 ufun
  val ir_remote_control_a : int ufun
  val alternate_ir_seeker : int_tuple4 ufun
  val calibration : int_tuple2 ufun
end


module LegoEv3InfraredSensor (DI : DEVICE_INFO)
  (P : OUTPUT_PORT) = struct
  type lego_ev3_infrared_sensor_modes = 
    | IR_PROX
    | IR_SEEKER
    | IR_REMOTE
    | IR_REM_A
    | IR_S_ALT
    | IR_CAL
  
  
  module LegoEv3InfraredSensorCommands = struct
    type commands = unit
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module LegoEv3InfraredSensorModes = struct
    type modes = lego_ev3_infrared_sensor_modes
    let modes_of_string = function
      | "ir-prox" -> IR_PROX
      | "ir-seeker" -> IR_SEEKER
      | "ir-remote" -> IR_REMOTE
      | "ir-rem-a" -> IR_REM_A
      | "ir-s-alt" -> IR_S_ALT
      | "ir-cal" -> IR_CAL
      | _ -> assert false
    
    let string_of_modes = function
      | IR_PROX -> "ir-prox"
      | IR_SEEKER -> "ir-seeker"
      | IR_REMOTE -> "ir-remote"
      | IR_REM_A -> "ir-rem-a"
      | IR_S_ALT -> "ir-s-alt"
      | IR_CAL -> "ir-cal"
    let default_mode = IR_PROX
  end
  
  
  module LegoEv3InfraredSensorPathFinder = Path_finder.Make(struct
    let prefix = "/sys/class/lego-sensor"
    let conditions = [
      ("name", "lego-ev3-ir");
      ("port", string_of_output_port P.output_port)
    ]
  end)
  
  include Make_abstract_sensor(LegoEv3InfraredSensorCommands)
    (LegoEv3InfraredSensorModes)(DI)
    (LegoEv3InfraredSensorPathFinder)
    
    let proximity = checked_read read1 IR_PROX
    let ir_seeker = checked_read read8 IR_SEEKER
    let ir_remote_control = checked_read read4 IR_REMOTE
    let ir_remote_control_a = checked_read read1 IR_REM_A
    let alternate_ir_seeker = checked_read read4 IR_S_ALT
    let calibration = checked_read read2 IR_CAL
  end
  
  
(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

