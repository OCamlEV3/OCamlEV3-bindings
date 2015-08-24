
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

module type HI_TECHNIC_NXT_I_R_RECEIVER_SENSOR = sig
  
  type hi_technic_nxt_i_r_receiver_sensor_modes = 
    | ONE_MOTOR
    | EIGHT_MOTOR
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := hi_technic_nxt_i_r_receiver_sensor_modes
  
  val single_motor_control : int ufun
  val eight_motor_control : int_tuple8 ufun
end


module HiTechnicNxtIRReceiverSensor (DI : DEVICE_INFO)
  (P : OUTPUT_PORT) = struct
  type hi_technic_nxt_i_r_receiver_sensor_modes = 
    | ONE_MOTOR
    | EIGHT_MOTOR
  
  
  module HiTechnicNxtIRReceiverSensorCommands = struct
    type commands = unit
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module HiTechnicNxtIRReceiverSensorModes = struct
    type modes = hi_technic_nxt_i_r_receiver_sensor_modes
    let modes_of_string = function
      | "1-motor" -> ONE_MOTOR
      | "8-motor" -> EIGHT_MOTOR
      | _ -> assert false
    
    let string_of_modes = function
      | ONE_MOTOR -> "1-motor"
      | EIGHT_MOTOR -> "8-motor"
    let default_mode = ONE_MOTOR
  end
  
  
  module HiTechnicNxtIRReceiverSensorPathFinder = Path_finder.Make(struct
    let prefix = "/sys/class/lego-sensor"
    let conditions = [
      ("name", "ht-nxt-ir-receiver");
      ("port", string_of_output_port P.output_port)
    ]
  end)
  
  include Make_abstract_sensor(HiTechnicNxtIRReceiverSensorCommands)
    (HiTechnicNxtIRReceiverSensorModes)(DI)
    (HiTechnicNxtIRReceiverSensorPathFinder)
    
    let single_motor_control = checked_read read1 ONE_MOTOR
    let eight_motor_control = checked_read read8 EIGHT_MOTOR
  end
  
  
(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

