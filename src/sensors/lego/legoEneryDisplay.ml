
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

module type LEGO_ENERY_DISPLAY = sig
  type lego_enery_display_commands = unit
  type lego_enery_display_modes = 
    | IN_VOLT
    | IN_AMP
    | OUT_VOLT
    | OUT_AMP
    | JOUL
    | IN_WATT
    | OUT_WATT
    | ALL
  
  include Sensor.AbstractSensor
    with type commands := lego_enery_display_commands
     and type modes    := lego_enery_display_modes
  
  val input_voltage : int ufun
  val input_current : int ufun
  val output_voltage : int ufun
  val output_current : int ufun
  val energy : int ufun
  val input_power : int ufun
  val output_power : int ufun
  val energy_all_values : int_tuple7 ufun
end

module LegoEneryDisplay (DI : DEVICE_INFO)
    (P : OUTPUT_PORT) = struct
  type lego_enery_display_commands = unit
  type lego_enery_display_modes = 
    | IN_VOLT
    | IN_AMP
    | OUT_VOLT
    | OUT_AMP
    | JOUL
    | IN_WATT
    | OUT_WATT
    | ALL
  
  module LegoEneryDisplayCommands = struct
    type commands = lego_enery_display_commands
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module LegoEneryDisplayModes = struct
    type modes = lego_enery_display_modes
    let modes_of_string = function
      | "in-volt" -> IN_VOLT
      | "in-amp" -> IN_AMP
      | "out-volt" -> OUT_VOLT
      | "out-amp" -> OUT_AMP
      | "joul" -> JOUL
      | "in-watt" -> IN_WATT
      | "out-watt" -> OUT_WATT
      | "all" -> ALL
      | _ -> assert false
    
    let string_of_modes = function
      | IN_VOLT -> "in-volt"
      | IN_AMP -> "in-amp"
      | OUT_VOLT -> "out-volt"
      | OUT_AMP -> "out-amp"
      | JOUL -> "joul"
      | IN_WATT -> "in-watt"
      | OUT_WATT -> "out-watt"
      | ALL -> "all"
    
    let default_mode = IN_VOLT
  end
  
  module LegoEneryDisplayPathFinder = Path_finder.Make(struct
      let prefix = "/sys/class/lego-sensor"
      let conditions = [
        ("name", "lego-power-storage");
        ("port", string_of_output_port P.output_port)
      ]
    end)
  
  include Make_abstract_sensor(LegoEneryDisplayCommands)
      (LegoEneryDisplayModes)(DI)(LegoEneryDisplayPathFinder)
  
  let input_voltage = checked_read read1 IN_VOLT
  let input_current = checked_read read1 IN_AMP
  let output_voltage = checked_read read1 OUT_VOLT
  let output_current = checked_read read1 OUT_AMP
  let energy = checked_read read1 JOUL
  let input_power = checked_read read1 IN_WATT
  let output_power = checked_read read1 OUT_WATT
  let energy_all_values = checked_read read7 ALL
end


(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

