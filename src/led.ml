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
open Path_finder

module type LED_STRUCTURE = sig
  type position
  type color
  val string_of_position : position -> string
  val string_of_color : color -> string
end

module type LED_INFOS = sig
  type position
  type color
  val position : position
  val color : color
  include DEVICE_INFO
end

module type LED_DEVICE = sig
  include DEVICE
  val max_brightness : int
  val min_brightness : int
  val set_brightness : int -> unit
  val get_brightness : ?force:bool -> unit -> int
  val turn_off : unit -> unit
  val turn_on : unit -> unit
end

module Make_led
    (LS : LED_STRUCTURE)
    (LI : LED_INFOS with
      type position := LS.position and type color := LS.color)
    (P : PATH_FINDER) =
struct
  include Make_device(LI)(P)

  type led = {
    mutable brightness : int
  }

  let led = { brightness = 0 }
  
  let max_brightness = 100
  let min_brightness = 0

  let connect () =
    connect ();
    led.brightness <- action_read IO.read_int

  let set_brightness i =
    if i < min_brightness || i > max_brightness then
      raise (Invalid_argument
               (Printf.sprintf "%s -> invalid brightness %d." LI.name i))
    else if not (i = led.brightness) then
      action_write IO.write_int i

  let get_brightness ?(force = false) () =
    fail_when_disconnected ();
    if force then begin
      let b = action_read IO.read_int in
      set_brightness b;
      b
    end else
      led.brightness

  let turn_off () = set_brightness min_brightness
      
  let turn_on () = set_brightness max_brightness
end

(* Default creation, according to ev3dev standard documentation *)

module DefaultLedStructure = struct
  type position = Left | Right
  type color = Green | Red

  let string_of_position = function
    | Left -> "left"
    | Right -> "right"

  let string_of_color = function
    | Green -> "green"
    | Red -> "red"
end

open DefaultLedStructure

module Default_make (LI : sig
                       val position : position
                       val color : color
                     end) =
  Make_led
    (DefaultLedStructure)
    (struct
      type position = DefaultLedStructure.position
      type color = DefaultLedStructure.color
      let position = LI.position
      let color = LI.color
      let name =
        Printf.sprintf "led:%s:%s"
          (string_of_position LI.position)
          (string_of_color LI.color)
      let multiple_connection = true
    end)
    (Path_finder.Make_absolute(struct
        let path =
          Printf.sprintf "/sys/class/leds/ev3:%s:%s/"
            (string_of_position LI.position)
            (string_of_color LI.color)
      end))

module LedLeftGreen = Default_make(struct
    let position = Left
    let color    = Green
  end)

module LedLeftRed = Default_make(struct
    let position = Left
    let color    = Red
  end)

module LedRightGreen = Default_make(struct
    let position = Right
    let color    = Green
  end)

module LedRightRed = Default_make(struct
    let position = Right
    let color    = Red
  end)

(*
Local Variables:
compile-command: "make -C .."
End:
*)
