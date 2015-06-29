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

open Motors

type command =
  | RunForever
  | RunToAbsPos
  | RunToRelPos
  | RunTimed
  | RunDirect
  | Stop
  | Reset

type polarity =
  | Normal
  | Inverted

and regulation_mode =
  | On
  | Off

and state =
  | Running
  | Ramping
  | Holding
  | Stalled

and stop_command =
  | Coast
  | Brake
  | Hold




exception No_tacho_motor


let connect_tacho_motor p =
  try
    let devices = "/sys/bus/lego/devices/" in
    let port = port_wrapper p in
    let motor_bus =
      Sys.readdir devices |> Array.to_list |>
      get_file (Str.regexp (port ^ ":lego-ev3-\\(l\\|m\\)-motor"))
    in
    let dir =
      Sys.readdir (devices ^ motor_bus ^ "/tacho-motor/") |>
      Array.to_list |>
      get_file (Str.regexp "motor[0-9]+")
    in
    TachoMotor (p, devices ^ motor_bus ^ "/tacho-motor/" ^ dir ^ "/")
  with Not_found ->
    raise No_tacho_motor

(* Write / Read functions *)


let read_polarity file motor =
  let polarity_of_string = function
    | "normal"    -> Normal
    | "inverted"  -> Inverted
    | _           -> raise (Failure "Not an polarity")
  in read_typed_data polarity_of_string file motor

let write_polarity file polarity motor =
  let string_of_polarity = function
    | Normal   -> "normal"
    | Inverted -> "inverted"
  in write_typed_data string_of_polarity file polarity motor

let write_command file command motor =
  let string_of_command = function
    | RunForever  -> "run-forever"
    | RunToAbsPos -> "run-to-abs-pos"
    | RunToRelPos -> "run-to-rel-pos"
    | RunTimed    -> "run-timed"
    | RunDirect   -> "run-direct"
    | Stop        -> "stop"
    | Reset       -> "reset"
  in write_typed_data string_of_command file command motor

let read_regulation file motor =
  let regulation_of_string = function
    | "on"    -> On
    | "off"   -> Off
    | _       -> raise (Failure "Not a regulation mode")
  in read_typed_data regulation_of_string file motor

let write_regulation file polarity motor =
  let string_of_regulation = function
    | On    -> "on"
    | Off   -> "off"
  in write_typed_data string_of_regulation file polarity motor

let read_states file motor =
  let state_of_string = function
    | "running" -> Running
    | "ramping" -> Ramping
    | "holding" -> Holding
    | "stalled" -> Stalled
    | _ -> raise (Failure "Not a state")
  in
  let states_of_string s =
    let states = Str.(split (regexp " ") s) in
    List.map state_of_string states
  in read_typed_data states_of_string file motor

let read_scommand file motor =
  let scommand_of_string = function
    | "coast"  -> Coast
    | "brake"  -> Brake
    | "hold"   -> Hold
    | _         -> raise (Failure "Not an stop command")
  in read_typed_data scommand_of_string file motor

let write_scommand file scom motor =
  let string_of_scommand = function
    | Coast -> "coast"
    | Brake -> "brake"
    | Hold  -> "hold"
  in write_typed_data string_of_scommand file scom motor


(* Tacho-Motor Wrappers *)

(* Official *)

let max_speed = 750
let min_speed = -max_speed

let run_command           = write_command "command"
let count_per_rot         = read_int "count_per_rot"
let duty_cycle            = read_int "duty_cycle"
let duty_cycle_sp         = read_int "duty_cycle_sp"
let set_duty_cycle_sp     = write_int "duty_cycle_sp"
let encoder_polarity      = read_polarity "encoder_polarity"
let set_encoder_polarity  = write_polarity "encoder_polarity"
let polarity              = read_polarity "polarity"
let set_polarity          = write_polarity "polarity"
let position              = read_int "position"
let set_position          = write_int "position"
let position_sp           = read_int "position_sp"
let set_position_sp       = write_int "position_sp"
let speed                 = read_int "speed"
let speed_sp              = read_int "speed_sp"
let set_speed_sp i        = 
  let i =
    (* low speed make the motor doing weird things. *)
    if i < 20 && i > -20 then 0
    else if i > 750 then 750
    else if i < -750 then -750 else i
  in write_int "speed_sp" i
let ramp_up_sp            = read_int "ramp_up_sp"
let set_ramp_up_sp        = write_int "ramp_up_sp"
let ramp_down_sp          = read_int "ramp_down_sp"
let set_ramp_down_sp      = write_int "ramp_down_sp"
let speed_regulation      = read_regulation "speed_regulation"
let set_speed_regulation  = write_regulation "speed_regulation"
let state                 = read_states "state"
let stop_command          = read_scommand "stop_command"
let set_stop_command      = write_scommand "stop_command"
let time_sp               = read_int "time_sp"
let set_time_sp           = write_int "time_sp"


(* Added *)

let is_moving m =
  let s = speed m in
  s < -20 || s > 20

let matches_state s m     = List.exists (fun sta -> sta = s) (state m)
let is_running m          = matches_state Running m
let is_ramping m          = matches_state Ramping m
let is_holding m          = matches_state Holding m
let is_stalled m          = matches_state Stalled m


let run_forever m     = run_command RunForever m
let run_to_abs_pos m  = run_command RunToAbsPos m
let run_to_rel_pos m  = run_command RunToRelPos m
let run_timed m       = run_command RunTimed m
let run_direct m      = run_command RunDirect m
let stop m            = run_command Stop m
let reset m           = run_command Reset m


let stopc sc m =
  set_stop_command sc m;
  stop m

let hold m    = stopc Hold m
let coast m   = stopc Coast m
let brake m   = stopc Brake m


let toggle_run m =
  if is_running m then
    hold m
  else
    run_direct m


let emergency_stop m = reset m

let emergency_stop_port : port -> unit =
  function port ->
    try
      let motor = connect_tacho_motor port in
      emergency_stop motor
    with _ -> ()

let emergency_stop_ports : port list -> unit =
  function ports ->
    List.iter emergency_stop_port ports

let emergency_stop_ports_and_quit : port list -> unit =
  function ports ->
    emergency_stop_ports ports;
    exit 0

let _ =
  let open Sys in
  let ports = [OutA; OutB; OutC; OutD] in
  at_exit (fun () -> emergency_stop_ports ports);
  set_signal sigint
    (Signal_handle (fun _ -> emergency_stop_ports_and_quit ports))

