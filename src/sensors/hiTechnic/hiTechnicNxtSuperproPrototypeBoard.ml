
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

module type HI_TECHNIC_NXT_SUPERPRO_PROTOTYPE_BOARD = sig
  type hi_technic_nxt_superpro_prototype_board_commands = unit
  type hi_technic_nxt_superpro_prototype_board_modes = 
    | AIN
    | DIN
    | DOUT
    | DCTRL
    | STROBE
    | LED
    | AOUT_ZERO
    | AOUT_ONE
  
  include Sensor.AbstractSensor
    with type commands := hi_technic_nxt_superpro_prototype_board_commands
     and type modes    := hi_technic_nxt_superpro_prototype_board_modes
  
  val analog_inputs : int_tuple4 ufun
  val digital_inputs : int ufun
  val digital_outputs : int ufun
  val digital_controls : int ufun
  val strobe_output : int ufun
  val led_control : int ufun
  val analog_output_o0 : int_tuple5 ufun
  val analog_output_o1 : int_tuple5 ufun
end

module HiTechnicNxtSuperproPrototypeBoard (DI : DEVICE_INFO)
    (P : OUTPUT_PORT) = struct
  type hi_technic_nxt_superpro_prototype_board_commands = unit
  type hi_technic_nxt_superpro_prototype_board_modes = 
    | AIN
    | DIN
    | DOUT
    | DCTRL
    | STROBE
    | LED
    | AOUT_ZERO
    | AOUT_ONE
  
  module HiTechnicNxtSuperproPrototypeBoardCommands = struct
    type commands = hi_technic_nxt_superpro_prototype_board_commands
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module HiTechnicNxtSuperproPrototypeBoardModes = struct
    type modes = hi_technic_nxt_superpro_prototype_board_modes
    let modes_of_string = function
      | "ain" -> AIN
      | "din" -> DIN
      | "dout" -> DOUT
      | "dctrl" -> DCTRL
      | "strobe" -> STROBE
      | "led" -> LED
      | "aout-0" -> AOUT_ZERO
      | "aout-1" -> AOUT_ONE
      | _ -> assert false
    
    let string_of_modes = function
      | AIN -> "ain"
      | DIN -> "din"
      | DOUT -> "dout"
      | DCTRL -> "dctrl"
      | STROBE -> "strobe"
      | LED -> "led"
      | AOUT_ZERO -> "aout-0"
      | AOUT_ONE -> "aout-1"
    
    let default_mode = AIN
  end
  
  module HiTechnicNxtSuperproPrototypeBoardPathFinder = Path_finder.Make(struct
      let prefix = "/sys/class/lego-sensor"
      let conditions = [
        ("name", "ht-super-pro");
        ("port", string_of_output_port P.output_port)
      ]
    end)
  
  include Make_abstract_sensor(HiTechnicNxtSuperproPrototypeBoardCommands)
      (HiTechnicNxtSuperproPrototypeBoardModes)(DI)
      (HiTechnicNxtSuperproPrototypeBoardPathFinder)
  
  let analog_inputs = checked_read read4 AIN
  let digital_inputs = checked_read read1 DIN
  let digital_outputs = checked_read read1 DOUT
  let digital_controls = checked_read read1 DCTRL
  let strobe_output = checked_read read1 STROBE
  let led_control = checked_read read1 LED
  let analog_output_o0 = checked_read read5 AOUT_ZERO
  let analog_output_o1 = checked_read read5 AOUT_ONE
end


(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

