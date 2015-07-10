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

  type led = {
    mutable brightness : int;
  }

  let current_led = {
    brightness = 0;
  }

  let max_brightness = 100

  let fail what value =
    M.fail (Invalid_value (Printf.sprintf "LedDevice [%s] : %d" what value))

  let set_brightness i =
    (if i < 0 || i > max_brightness then
       fail "set_brightness" i else M.return ()) >>
    match current_led.brightness = i with
    | false ->
      get_path () >>= fun path ->
      current_led.brightness <- i;
      IO.write ~usage:ReleaseAfterUse path (string_of_int i)
    | true ->
      M.return ()

  let get_brightness () =
    M.return current_led.brightness

  let connected = ref true
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

