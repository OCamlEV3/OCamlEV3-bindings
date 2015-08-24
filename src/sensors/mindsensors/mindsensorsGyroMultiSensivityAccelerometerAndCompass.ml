
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

module type MINDSENSORS_GYRO_MULTI_SENSIVITY_ACCELEROMETER_AND_COMPASS = sig
  type mindsensors_gyro_multi_sensivity_accelerometer_and_compass_commands = 
    | BEGIN_COMP_CAL
    | END_COMP_CAL
    | ACCEL_TWOG
    | ACCEL_FOURG
    | ACCEL_EIGHTG
    | ACCEL_ONESIXG
  
  type mindsensors_gyro_multi_sensivity_accelerometer_and_compass_modes = 
    | TILT
    | ACCESS
    | COMPASS
    | MAG
    | GYRO
  
  include Sensor.AbstractSensor
    with type commands := mindsensors_gyro_multi_sensivity_accelerometer_and_compass_commands
     and type modes    := mindsensors_gyro_multi_sensivity_accelerometer_and_compass_modes
  
  val tilt : int_tuple3 ufun
  val acceleration : int_tuple3 ufun
  val compass : int ufun
  val magnetic_field : int_tuple3 ufun
  val gyroscope : int_tuple3 ufun
end

module MindsensorsGyroMultiSensivityAccelerometerAndCompass
    (DI : DEVICE_INFO)
    (P : OUTPUT_PORT) = struct
  type mindsensors_gyro_multi_sensivity_accelerometer_and_compass_commands = 
    | BEGIN_COMP_CAL
    | END_COMP_CAL
    | ACCEL_TWOG
    | ACCEL_FOURG
    | ACCEL_EIGHTG
    | ACCEL_ONESIXG
  
  type mindsensors_gyro_multi_sensivity_accelerometer_and_compass_modes = 
    | TILT
    | ACCESS
    | COMPASS
    | MAG
    | GYRO
  
  module MindsensorsGyroMultiSensivityAccelerometerAndCompassCommands = struct
    type commands = mindsensors_gyro_multi_sensivity_accelerometer_and_compass_commands
    let string_of_commands = function
      | BEGIN_COMP_CAL -> "begin-comp-cal"
      | END_COMP_CAL -> "end-comp-cal"
      | ACCEL_TWOG -> "accel-2g"
      | ACCEL_FOURG -> "accel-4g"
      | ACCEL_EIGHTG -> "accel-8g"
      | ACCEL_ONESIXG -> "accel-16g"
    
  end
  
  module MindsensorsGyroMultiSensivityAccelerometerAndCompassModes = struct
    type modes = mindsensors_gyro_multi_sensivity_accelerometer_and_compass_modes
    let modes_of_string = function
      | "tilt" -> TILT
      | "access" -> ACCESS
      | "compass" -> COMPASS
      | "mag" -> MAG
      | "gyro" -> GYRO
      | _ -> assert false
    
    let string_of_modes = function
      | TILT -> "tilt"
      | ACCESS -> "access"
      | COMPASS -> "compass"
      | MAG -> "mag"
      | GYRO -> "gyro"
    
    let default_mode = TILT
  end
  
  module MindsensorsGyroMultiSensivityAccelerometerAndCompassPathFinder = Path_finder.Make(struct
      let prefix = "/sys/class/lego-sensor"
      let conditions = [
        ("name", "ms-absolute-imu");
        ("port", string_of_output_port P.output_port)
      ]
    end)
  
  include Make_abstract_sensor(MindsensorsGyroMultiSensivityAccelerometerAndCompassCommands)
      (MindsensorsGyroMultiSensivityAccelerometerAndCompassModes)(DI)
      (MindsensorsGyroMultiSensivityAccelerometerAndCompassPathFinder)
  
  let tilt = checked_read read3 TILT
  let acceleration = checked_read read3 ACCESS
  let compass = checked_read read1 COMPASS
  let magnetic_field = checked_read read3 MAG
  let gyroscope = checked_read read3 GYRO
end


(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

