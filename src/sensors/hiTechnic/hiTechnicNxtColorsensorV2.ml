
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

module type HI_TECHNIC_NXT_COLORSENSOR_V2 = sig
  type hi_technic_nxt_colorsensor_v2_commands = unit
  type hi_technic_nxt_colorsensor_v2_modes = 
    | COLOR
    | RED
    | GREEN
    | BLUE
    | WHITE
    | NORM
    | ALL
    | RAW
  
  include Sensor.AbstractSensor
    with type commands := hi_technic_nxt_colorsensor_v2_commands
     and type modes    := hi_technic_nxt_colorsensor_v2_modes
  
  val color : int ufun
  val red_value : int ufun
  val green_value : int ufun
  val blue_value : int ufun
  val white_value : int ufun
  val normalized_values : int_tuple4 ufun
  val all_values : int_tuple5 ufun
  val raw_values : int_tuple4 ufun
end

module HiTechnicNxtColorsensorV2 (DI : DEVICE_INFO)
    (P : OUTPUT_PORT) = struct
  type hi_technic_nxt_colorsensor_v2_commands = unit
  type hi_technic_nxt_colorsensor_v2_modes = 
    | COLOR
    | RED
    | GREEN
    | BLUE
    | WHITE
    | NORM
    | ALL
    | RAW
  
  module HiTechnicNxtColorsensorV2Commands = struct
    type commands = hi_technic_nxt_colorsensor_v2_commands
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module HiTechnicNxtColorsensorV2Modes = struct
    type modes = hi_technic_nxt_colorsensor_v2_modes
    let modes_of_string = function
      | "color" -> COLOR
      | "red" -> RED
      | "green" -> GREEN
      | "blue" -> BLUE
      | "white" -> WHITE
      | "norm" -> NORM
      | "all" -> ALL
      | "raw" -> RAW
      | _ -> assert false
    
    let string_of_modes = function
      | COLOR -> "color"
      | RED -> "red"
      | GREEN -> "green"
      | BLUE -> "blue"
      | WHITE -> "white"
      | NORM -> "norm"
      | ALL -> "all"
      | RAW -> "raw"
    
    let default_mode = COLOR
  end
  
  module HiTechnicNxtColorsensorV2PathFinder = Path_finder.Make(struct
      let prefix = "/sys/class/lego-sensor"
      let conditions = [
        ("name", "ht-nxt-color-v2");
        ("port", string_of_output_port P.output_port)
      ]
    end)
  
  include Make_abstract_sensor(HiTechnicNxtColorsensorV2Commands)
      (HiTechnicNxtColorsensorV2Modes)(DI)
      (HiTechnicNxtColorsensorV2PathFinder)
  
  let color = checked_read read1 COLOR
  let red_value = checked_read read1 RED
  let green_value = checked_read read1 GREEN
  let blue_value = checked_read read1 BLUE
  let white_value = checked_read read1 WHITE
  let normalized_values = checked_read read4 NORM
  let all_values = checked_read read5 ALL
  let raw_values = checked_read read4 RAW
end


(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

