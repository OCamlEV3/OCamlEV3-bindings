(******************************************************************************
 * The MIT License (MIT)                                                      *
 *                                                                            *
 * Copyright (c) 2015 OCamlEV3                                                *
 *  Loïc Runarvot <loic.runarvot[at]gmail.com>                                *
 *  Nicolas Tortrat-Gentilhomme <nicolas.tortrat[at]gmail.com>                *
 *  Nicolas Raymond <noci.64[at]orange.fr>                                    *
 *                                                                            *
 * Permission is hereby granted, free of charge, to any person obtaining a    *
 * copy of this software and associated documentation files (the "Software"), *
 * to deal in the Software without restriction, including without limitation  *
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,   *
 * and/or sell copies of the Software, and to permit persons to whom the      *
 * Software is furnished to do so, subject to the following conditions:       *
 *                                                                            *
 * The above copyright notice and this permission notice shall be included in *
 * all copies or substantial portions of the Software.                        *
 *                                                                            *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   *
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    *
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    *
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER        *
 * DEALINGS IN THE SOFTWARE.                                                  *
 *****************************************************************************)

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
end

module LedDevice (C : CORE) (I : LED_INFOS) =
struct
  open C
  open C.INFIX

  include Device(C)(struct
    let path =
      Printf.sprintf
        "/sys/class/leds/ev3:%s:%s/"
        (string_of_position I.position)
        (string_of_color    I.color)

    let exception_on_fail = true
  end)

  type led = {
    name : string;
    mutable brightness : int;
  }

  let current_led = {
    name       = Printf.sprintf
                   "Led:%s:%s"
                   (string_of_position I.position)
                   (string_of_color I.color);
    brightness = 0;
  }

  let max_brightness = 100

  let check_connection () =
    is_connected () >>= function
    | true  -> C.return ()
    | false -> C.fail (Is_not_connected current_led.name)

  let connect () =
    connect () >>
    get_path () >>= fun path ->
    IO.read_int path >>= fun brightness ->
    C.return (current_led.brightness <- brightness)

  let fail what value =
    C.fail (Invalid_value (Printf.sprintf "LedDevice [%s] : %d" what value))

  let set_brightness i =
    check_connection () >>
    (if i < 0 || i > max_brightness then
       fail "set_brightness" i else C.return ()) >>
    match current_led.brightness = i with
    | false ->
      get_path () >>= fun path ->
      current_led.brightness <- i;
      IO.write_int path i
    | true ->
      C.return ()

  let get_brightness () =
    check_connection () >>
    C.return current_led.brightness
end



(* Default LED, using Simple Monad *)

module LedLeftGreen = LedDevice(Core)(struct
  let position = Left
  let color    = Green
end)

module LedRightGreen = LedDevice(Core)(struct
  let position = Right
  let color    = Green
end)

module LedLeftRed = LedDevice(Core)(struct
  let position = Left
  let color    = Red
end)

module LedRightRed = LedDevice(Core)(struct
  let position = Right
  let color    = Red
end)



(* Lwt Led *)


module LedLeftGreenLwt = LedDevice(LwtCore)(struct
  let position = Left
  let color    = Green
end)

module LedRightGreenLwt = LedDevice(LwtCore)(struct
  let position = Right
  let color    = Green
end)

module LedLeftRedLwt = LedDevice(LwtCore)(struct
  let position = Left
  let color    = Red
end)

module LedRightRedLwt = LedDevice(LwtCore)(struct
  let position = Right
  let color    = Red
end)
