
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

module type MICROINFINITY_DIGITAL_GYROSCOPE_AND_ACCELEROMETER = sig
  
  type microinfinity_digital_gyroscope_and_accelerometer_modes = 
    | ANGLE
    | SPEED
    | ACCEL
    | ALL
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := microinfinity_digital_gyroscope_and_accelerometer_modes
  
  val angle : int ufun
  val rotational_speed : int ufun
  val acceleration : int_tuple3 ufun
  val all_values : int_tuple5 ufun
end


module MicroinfinityDigitalGyroscopeAndAccelerometer (DI : DEVICE_INFO)
  (P : OUTPUT_PORT) = struct
  type microinfinity_digital_gyroscope_and_accelerometer_modes = 
    | ANGLE
    | SPEED
    | ACCEL
    | ALL
  
  
  module MicroinfinityDigitalGyroscopeAndAccelerometerCommands = struct
    type commands = unit
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module MicroinfinityDigitalGyroscopeAndAccelerometerModes = struct
    type modes = microinfinity_digital_gyroscope_and_accelerometer_modes
    let modes_of_string = function
      | "angle" -> ANGLE
      | "speed" -> SPEED
      | "accel" -> ACCEL
      | "all" -> ALL
      | _ -> assert false
    
    let string_of_modes = function
      | ANGLE -> "angle"
      | SPEED -> "speed"
      | ACCEL -> "accel"
      | ALL -> "all"
    let default_mode = ANGLE
  end
  
  
  module MicroinfinityDigitalGyroscopeAndAccelerometerPathFinder = Path_finder.Make(struct
    let prefix = "/sys/class/lego-sensor"
    let conditions = [
      ("name", "mi-xg1300l");
      ("port", string_of_output_port P.output_port)
    ]
  end)
  
  include Make_abstract_sensor(MicroinfinityDigitalGyroscopeAndAccelerometerCommands)
    (MicroinfinityDigitalGyroscopeAndAccelerometerModes)(DI)
    (MicroinfinityDigitalGyroscopeAndAccelerometerPathFinder)
    
    let angle = checked_read read1 ANGLE
    let rotational_speed = checked_read read1 SPEED
    let acceleration = checked_read read3 ACCEL
    let all_values = checked_read read5 ALL
  end
  
  
(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

