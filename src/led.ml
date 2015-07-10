
open Core
open Device

type position = Left  | Right
type color    = Green | Red

let string_of_position = function
  | Left  -> "left"
  | Right -> "right"

let string_of_color = function
  | Green -> "green"
  | Red   -> "red"

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

module LedDevice (M : MONAD) (I : LED_INFOS) =
struct
  open M
  open M.INFIX

  include Device(M)(struct
    let path =
      Printf.sprintf
        "/sys/class/leds/ev3:%s:%s/"
        (string_of_position I.position)
        (string_of_color    I.color)

    let exception_on_fail = true
  end)

  let max_brightness = 100

  let set_brightness i =
    if i < 0 || i > max_brightness then
      raise (Invalid_value
               (Printf.sprintf "LedDevice [set_brightness] : %d" i))
    ;
    get_path () >>= fun path ->
    IO.write ~usage:ReleaseAfterUse path (string_of_int i)

  let get_brightness () =
    get_path () >>= fun path ->
    IO.read ~usage:ReleaseAfterUse path >>= fun x ->
    return (int_of_string x)

  let connected = ref false
  let is_connected () = M.return !connected
end



(* Default LED, using Simple Monad *)

module LedLeftGreen = LedDevice(SimpleMonad)(struct
  let position = Left
  let color    = Green
end)

module LedRightGreen = LedDevice(SimpleMonad)(struct
  let position = Right
  let color    = Green
end)

module LedLeftRed = LedDevice(SimpleMonad)(struct
  let position = Left
  let color    = Red
end)

module LedRightRed = LedDevice(SimpleMonad)(struct
  let position = Right
  let color    = Red
end)



(* Lwt Led *)


module LedLeftGreenLwt = LedDevice(LwtMonad)(struct
  let position = Left
  let color    = Green
end)

module LedRightGreenLwt = LedDevice(LwtMonad)(struct
  let position = Right
  let color    = Green
end)

module LedLeftRedLwt = LedDevice(LwtMonad)(struct
  let position = Left
  let color    = Red
end)

module LedRightRedLwt = LedDevice(LwtMonad)(struct
  let position = Right
  let color    = Red
end)

