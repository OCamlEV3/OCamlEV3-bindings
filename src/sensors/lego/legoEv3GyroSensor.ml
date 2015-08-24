
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

module type LEGO_EV3_GYRO_SENSOR = sig
  
  type lego_ev3_gyro_sensor_modes = 
    | GYRO_ANG
    | GYRO_RATE
    | GYRO_FAS
    | GYRO_G_AND_A
    | GYRO_CAL
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := lego_ev3_gyro_sensor_modes
  
  val angle : int ufun
  val rotational_speed : int ufun
  val raw_values : int ufun
  val angle_and_rotational_speed : int_tuple2 ufun
  val calibration : int_tuple4 ufun
end


module LegoEv3GyroSensor (DI : DEVICE_INFO)
  (P : OUTPUT_PORT) = struct
  type lego_ev3_gyro_sensor_modes = 
    | GYRO_ANG
    | GYRO_RATE
    | GYRO_FAS
    | GYRO_G_AND_A
    | GYRO_CAL
  
  
  module LegoEv3GyroSensorCommands = struct
    type commands = unit
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module LegoEv3GyroSensorModes = struct
    type modes = lego_ev3_gyro_sensor_modes
    let modes_of_string = function
      | "gyro-ang" -> GYRO_ANG
      | "gyro-rate" -> GYRO_RATE
      | "gyro-fas" -> GYRO_FAS
      | "gyro-g&a" -> GYRO_G_AND_A
      | "gyro-cal" -> GYRO_CAL
      | _ -> assert false
    
    let string_of_modes = function
      | GYRO_ANG -> "gyro-ang"
      | GYRO_RATE -> "gyro-rate"
      | GYRO_FAS -> "gyro-fas"
      | GYRO_G_AND_A -> "gyro-g&a"
      | GYRO_CAL -> "gyro-cal"
    let default_mode = GYRO_ANG
  end
  
  
  module LegoEv3GyroSensorPathFinder = Path_finder.Make(struct
    let prefix = "/sys/class/lego-sensor"
    let conditions = [
      ("name", "lego-ev3-gyro");
      ("port", string_of_output_port P.output_port)
    ]
  end)
  
  include Make_abstract_sensor(LegoEv3GyroSensorCommands)
    (LegoEv3GyroSensorModes)(DI)
    (LegoEv3GyroSensorPathFinder)
    
    let angle = checked_read read1 GYRO_ANG
    let rotational_speed = checked_read read1 GYRO_RATE
    let raw_values = checked_read read1 GYRO_FAS
    let angle_and_rotational_speed = checked_read read2 GYRO_G_AND_A
    let calibration = checked_read read4 GYRO_CAL
  end
  
  
(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

