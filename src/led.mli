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

(** This module handles Led on a EV3 robot. *)

(** {2 Leds creation} *)

module type LED_STRUCTURE = sig
  type position
  (** The type of the position. *)

  type color
  (** The type of colors. *)

  val string_of_position : position -> string
  (** [string_of_position position] translate position into a string *)

  val string_of_color : color -> string
  (** [string_of_color color] translate color into a string *)
end
(** Representation of a structure of a led.
    The representation to handle position and colorisation. By default, on a
    basic ev3 robot, it comes with two position (left and right) and two color
    (green and red) *)


module type LED_INFOS = sig
  type position
  (** Should be the same type as given on the Led Structure. *)
  
  type color
  (** Should be the same type as given on the Led Structure. *)
  
  val position : position
  (** The led position *)

  val color : color
  (** The led color *)
  
  include Device.DEVICE_INFO
end
(** Gives information about the led : what is the given position and the given
    color, its name and if multiple connection are allowed *)


module type LED_DEVICE = sig
  include Device.DEVICE
    
  val max_brightness : int
  (** This is the max brightness possible to allow. *)
  
  val min_brightness : int
  (** This is the min brightness possible to allow. *)
    
  val set_brightness : int -> unit
  (** [set_brightness i] change the brightness value of the led to [i].
      @raise Invalid_argument if [i < min_brightness] or [i > max_brightness] *)

  val get_brightness : ?force:bool -> unit -> int
  (** [get_brightness ?force ()] returns the brightness. If [force] is set to
      true then, this function will read the value into the file instead of
      the memoized value. *)

  val turn_off : unit -> unit
  (** [turn_off ()] set the brightness to [min_brightness] *)
    
  val turn_on : unit -> unit
  (** [turn_on ()] set the brightness to [max_brightness] *)
end
(** Handles a real led, allowing to change brightness of color. *)


module Make_led
    (LS : LED_STRUCTURE)
    (LI : LED_INFOS with
      type position := LS.position and type color := LS.color)
    (P : Path_finder.PATH_FINDER) : LED_DEVICE
(** Creates a led according of all informations given. *)


(** {2 Default Leds} *)

module LedLeftGreen  : LED_DEVICE
(** The green color of the left led. *)

module LedLeftRed    : LED_DEVICE
(** The red color of the left led. *)

module LedRightGreen : LED_DEVICE
(** The green color of the red led. *)

module LedRightRed   : LED_DEVICE
(** The red color of the red led. *)


(*
Local Variables:
compile-command: "make -C .."
End:
*)
