
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

module type HI_TECHNIC_NXT_I_R_SEEKER_V2 = sig
  
  type hi_technic_nxt_i_r_seeker_v2_modes = 
    | DC
    | AC
    | DC_ALL
    | AC_ALL
  
  include Sensor.AbstractSensor
    with type commands := unit
     and type modes    := hi_technic_nxt_i_r_seeker_v2_modes
  
  val unmodulated_direction : int ufun
  val modulated_direction : int ufun
  val unmodulated_all_values : int_tuple7 ufun
  val modulated_all_values : int_tuple6 ufun
end


module HiTechnicNxtIRSeekerV2 (DI : DEVICE_INFO)
  (P : OUTPUT_PORT) = struct
  type hi_technic_nxt_i_r_seeker_v2_modes = 
    | DC
    | AC
    | DC_ALL
    | AC_ALL
  
  
  module HiTechnicNxtIRSeekerV2Commands = struct
    type commands = unit
    let string_of_commands = function
      | _ -> failwith "commands are not available for this sensor."
    
  end
  
  module HiTechnicNxtIRSeekerV2Modes = struct
    type modes = hi_technic_nxt_i_r_seeker_v2_modes
    let modes_of_string = function
      | "dc" -> DC
      | "ac" -> AC
      | "dc-all" -> DC_ALL
      | "ac-all" -> AC_ALL
      | _ -> assert false
    
    let string_of_modes = function
      | DC -> "dc"
      | AC -> "ac"
      | DC_ALL -> "dc-all"
      | AC_ALL -> "ac-all"
    let default_mode = DC
  end
  
  
  module HiTechnicNxtIRSeekerV2PathFinder = Path_finder.Make(struct
    let prefix = "/sys/class/lego-sensor"
    let conditions = [
      ("name", "ht-nxt-ir-seek-v2");
      ("port", string_of_output_port P.output_port)
    ]
  end)
  
  include Make_abstract_sensor(HiTechnicNxtIRSeekerV2Commands)
    (HiTechnicNxtIRSeekerV2Modes)(DI)
    (HiTechnicNxtIRSeekerV2PathFinder)
    
    let unmodulated_direction = checked_read read1 DC
    let modulated_direction = checked_read read1 AC
    let unmodulated_all_values = checked_read read7 DC_ALL
    let modulated_all_values = checked_read read6 AC_ALL
  end
  
  
(*
Local Variables:
compile-command: "make -C ../.."
End:
*)

