
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

module type LEGO_EV3_ULTRASONIC_SENSOR = sig
  type lego_ev3_ultrasonic_sensor_commands = unit
  type lego_ev3_ultrasonic_sensor_modes = 
    | US_DIST_CM
    | US_DIST_IN
    | US_LISTEN
    | US_SI_CM
    | US_SI_IN
    | US_DC_CM
    | US_DC_IN
  
  include Sensor.AbstractSensor
    with type commands := lego_ev3_ultrasonic_sensor_commands
     and type modes    := lego_ev3_ultrasonic_sensor_modes
  
  val continuous_dist_cm : int ufun
  val continuous_dist_in : int ufun
  val listen : int ufun
  val single_dist_cm : int ufun
  val single_dist_in : int ufun
  val us_dc_cm : int ufun
  val us_dc_in : int ufun
end

module LegoEv3UltrasonicSensor (DI : DEVICE_INFO)
    (P : OUTPUT_PORT) = struct
  type lego_ev3_ultrasonic_sensor_commands = unit
  type lego_ev3_ultrasonic_sensor_modes = 
    | US_DIST_CM
    | US_DIST_IN
    | US_LISTEN
    | US_SI_CM
    | US_SI_IN
    | US_DC_CM
    | US_DC_IN
  
  module LegoEv3UltrasonicSensorCommands = struct
    type commands = lego_ev3_ultrasonic_sensor_commands
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module LegoEv3UltrasonicSensorModes = struct
    type modes = lego_ev3_ultrasonic_sensor_modes
    let modes_of_string = function
      | "us-dist-cm" -> US_DIST_CM
      | "us-dist-in" -> US_DIST_IN
      | "us-listen" -> US_LISTEN
      | "us-si-cm" -> US_SI_CM
      | "us-si-in" -> US_SI_IN
      | "us-dc-cm" -> US_DC_CM
      | "us-dc-in" -> US_DC_IN
      | _ -> assert false
    
    let string_of_modes = function
      | US_DIST_CM -> "us-dist-cm"
      | US_DIST_IN -> "us-dist-in"
      | US_LISTEN -> "us-listen"
      | US_SI_CM -> "us-si-cm"
      | US_SI_IN -> "us-si-in"
      | US_DC_CM -> "us-dc-cm"
      | US_DC_IN -> "us-dc-in"
    
    let default_mode = US_DIST_CM
  end
  
  module LegoEv3UltrasonicSensorPathFinder = Path_finder.Make(struct
      let prefix = "/sys/class/lego-sensor"
      let conditions = [
        ("name", "lego-ev3-us");
        ("port", string_of_output_port P.output_port)
      ]
    end)
  
  include Make_abstract_sensor(LegoEv3UltrasonicSensorCommands)
      (LegoEv3UltrasonicSensorModes)(DI)(LegoEv3UltrasonicSensorPathFinder)
  
  let continuous_dist_cm = checked_read read1 US_DIST_CM
  let continuous_dist_in = checked_read read1 US_DIST_IN
  let listen = checked_read read1 US_LISTEN
  let single_dist_cm = checked_read read1 US_SI_CM
  let single_dist_in = checked_read read1 US_SI_IN
  let us_dc_cm = checked_read read1 US_DC_CM
  let us_dc_in = checked_read read1 US_DC_IN
end


(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

