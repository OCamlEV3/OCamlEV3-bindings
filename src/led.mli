
open Core
open Device

type position = Left  | Right
type color    = Green | Red

module type LED_INFOS = sig
  val position : position
  val color : color
end

module type LED_DEVICE = sig
  include DEVICE
  val max_brightness : int
  val set_brightness : int  -> unit m
  val get_brightness : unit -> int  m
  val is_connected   : unit -> bool m
end

(* Default LED, using Simple Monad *)
module LedLeftGreen  : LED_DEVICE
module LedRightGreen : LED_DEVICE
module LedLeftRed    : LED_DEVICE
module LedRightRed   : LED_DEVICE


(* Lwt Led *)
module LedLeftGreenLwt  : LED_DEVICE with type 'a m = 'a Lwt.t
module LedRightGreenLwt : LED_DEVICE with type 'a m = 'a Lwt.t
module LedLeftRedLwt    : LED_DEVICE with type 'a m = 'a Lwt.t
module LedRightRedLwt   : LED_DEVICE with type 'a m = 'a Lwt.t

