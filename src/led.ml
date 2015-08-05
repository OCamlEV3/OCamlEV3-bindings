
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
