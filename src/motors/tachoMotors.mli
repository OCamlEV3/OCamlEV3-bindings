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

(**	Motor Commands *)
type command =
  | RunForever
  | RunToAbsPos
  | RunToRelPos
  | RunTimed
  | RunDirect
  | Stop
  | Reset

(** Motor encoding. *)
type polarity =
  | Normal        (** normal   polarity *)
  | Inverted      (** inverted polarity *)

(** Motor's regulation mode. *)
and regulation_mode =
  | On            (** on  state *)
  | Off           (** off state *)

(** Motor state. *)
and state =
  | Running
  | Ramping
  | Holding
  | Stalled

(** Motor stop modes. *)
and stop_command =
  | Coast
  | Brake
  | Hold


(** Exception raise when the given motor is not a tacho motor. *)
exception No_tacho_motor

(**	[connect_tacho_motor p] tries to connect to a tacho-motor
    pluged into the port [p]. Raise [No_tacho_motor] if no
    tacho_motor was found. *)
val connect_tacho_motor : port -> tacho_motor t



(** {3 Write / Read functions} *)


(**	[read_polarity f m] read the polarity from a certain
    file [f] situated in the [motor]'s path. *)
val read_polarity : string -> tacho_motor t -> polarity

(**	[write_polarity f n m] write the polarity [n] in a certain
    file [f] situated in the [motor]'s path. *)
val write_polarity : string -> polarity -> tacho_motor t -> unit

(**	[write_command f n m] write the command [n] in a certain
    file [f] situated in the [motor]'s path. *)
val write_command : string -> command -> tacho_motor t -> unit

(**	[read_regulation f m] read the regulation_mode from a certain
    file [f] situated in the [motor]'s path. *)
val read_regulation : string -> tacho_motor t -> regulation_mode

(**	[write_regulation f n m] write the regulation_mode [n] in a certain
    file [f] situated in the [motor]'s path. *)
val write_regulation : string -> regulation_mode -> tacho_motor t -> unit

(**	[read_states f m] read the states from a certain
    file [f] situated in the [motor]'s path. *)
val read_states : string -> tacho_motor t -> state list

(**	[read_scommand f m] read the stop command from a certain
    file [f] situated in the [motor]'s path. *)
val read_scommand : string -> tacho_motor t -> stop_command

(**	[write_scommand f n m] write the stop command [n] in a certain
    file [f] situated in the [motor]'s path. *)
val write_scommand : string -> stop_command -> tacho_motor t -> unit



(**	{3 Tacho-Motor Wrappers} *)


(** {7 Official EV3 Wrappers} *)

val max_speed : int

val min_speed : int

(**	[run_command m c] runs the command [c] on the motor [m]. *)
val run_command : command -> tacho_motor t -> unit

(** [count_per_rot m] gives the number of count per rotation in the
    motor [m]. *)
val count_per_rot : tacho_motor t -> int

(** [duty_cycle m] gives the actual value of tacho-motor [m]'s
    duty-cycle. *)
val duty_cycle : tacho_motor t -> int

(** [duty_cycle_sp m] gives the actual value of tacho-motor [m]'s
    duty-cycle_sp. *)
val duty_cycle_sp : tacho_motor t -> int

(** [set_duty_cycle_sp spd m] set the duty_cycle_sp of the
    tacho-motor [m] to the new speed [spd]. *)
val set_duty_cycle_sp : int -> tacho_motor t -> unit

(** [encoder_polarity m] gives the actual value of tacho-motor [m]'s
    encoder_polarity. *)
val encoder_polarity : tacho_motor t -> polarity

(** [set_encoder_polarity pol m] set the encoder polarity of the
    tacho-motor [m] to the new polarity [pol]. *)
val set_encoder_polarity : polarity -> tacho_motor t -> unit

(** [polarity m] gives the actual value of tacho-motor [m]'s
    polarity. *)
val polarity : tacho_motor t -> polarity

(** [set_polarity pol m] set the  polarity of the tacho-motor [m]
    to the new polarity [pol]. *)
val set_polarity : polarity -> tacho_motor t -> unit

(** [position m] returns the value of the current position of the robot.
    It a number of ticks made by the robot. *)
val position : tacho_motor t -> int

(** [set_position p m] can reset the motor's "position" to [p]. *)
val set_position : int -> tacho_motor t -> unit

(** [position_sp m] gives the actual value of tacho-motor [m]'s position_sp. *)
val position_sp : tacho_motor t -> int

(** [set_position_sp pos m] set the position_sp of the tacho-motor [m] to the
    new [position]. *)
val set_position_sp : int -> tacho_motor t -> unit

(** [speed m] gives the actual value of tacho-motor [m]'s speed in tacho count
    per seconds. *)
val speed : tacho_motor t -> int

(** [speed_sp m] gives the actual value of tacho-motor [m]'s speed_sp in tacho
    count per seconds *)
val speed_sp : tacho_motor t -> int

(** [set_speed_sp spd m] set the speed_sp of the tacho-motor [m] to the
    new speed [spd] in tacho count per seconds. *)
val set_speed_sp : int -> tacho_motor t -> unit

(** [ramp_up_sp m] gives the actual value of tacho-motor [m]'s ramp_up_sp in
    milliseconds. *)
val ramp_up_sp : tacho_motor t -> int

(** [set_ramp_up_sp time m] set the ramp_up_sp of the tacho-motor
    [m] to the new [time] in milliseconds. *)
val set_ramp_up_sp : int -> tacho_motor t -> unit

(** [ramp_down_sp m] gives the actual value of tacho-motor [m]'s ramp_down_sp in
    milliseconds. *)
val ramp_down_sp : tacho_motor t -> int

(** [set_ramp_down_sp time m] set the ramp_down_sp of the tacho-motor
    [m] to the new [time] in milliseconds. *)
val set_ramp_down_sp : int -> tacho_motor t -> unit

(** [speed_regulation m] gives the actual value of tacho-motor [m]'s
    speed_regulation. *)
val speed_regulation : tacho_motor t -> regulation_mode

(** [set_speed_regulation mode m] set the speed_regulation of the tacho-motor
    [m] to the new speed regulation [mode]. *)
val set_speed_regulation : regulation_mode -> tacho_motor t -> unit

(** [state m] gives the actual states of tacho-motor [m]. *)
val state : tacho_motor t -> state list

(** [stop_command m] gives the actual value of tacho-motor [m]'s stop_command. *)
val stop_command : tacho_motor t -> stop_command

(** [set_stop_command com m] set the stop_command of the tacho-motor
    [m] to the new command [com]. *)
val set_stop_command : stop_command -> tacho_motor t -> unit

(** [time_sp m] gives the actual value of tacho-motor [m]'s time_sp. *)
val time_sp : tacho_motor t -> int

(** [set_time_sp time m] set the time_sp of the tacho-motor [m] to the new
    time [time]. *)
val set_time_sp : int -> tacho_motor t -> unit


(**	{7 Added functionalities} *)

val is_moving : tacho_motor t -> bool

(** [is_running motor] verify if the motor is running. *)
val is_running : tacho_motor t -> bool

(** [is_ramping motor] verify if the motor is ramping. *)
val is_ramping : tacho_motor t -> bool

(** [is_holding motor] verify if the motor is holding. *)
val is_holding : tacho_motor t -> bool

(** [is_stalled motor] verify if the motor is stalled. *)
val is_stalled : tacho_motor t -> bool



(** [run_forever motor] turn on the motor in run_forever mode *)
val run_forever : tacho_motor t -> unit

(** [run_to_abs_pos motor] turn on the motor in run-to-abs-pos mode *)
val run_to_abs_pos : tacho_motor t -> unit

(** [run_to_rel_pos motor] turn on the motor in run-to-rel-pos mode *)
val run_to_rel_pos : tacho_motor t -> unit

(** [run_timed motor] turn on the motor in run-timed mode *)
val run_timed : tacho_motor t -> unit

(** [run_direct motor] turn on the motor in run-direct mode *)
val run_direct : tacho_motor t -> unit

(** [stop motor] stops the motor. *)
val stop : tacho_motor t -> unit

(** [reset motor] reset the state of the motor. *)
val reset : tacho_motor t -> unit


(** [hold motor] hold the [motor] *)
val hold : tacho_motor t -> unit

(** [caost motor] hold the [motor] *)
val coast : tacho_motor t -> unit

(** [brake motor] hold the [motor] *)
val brake : tacho_motor t -> unit



(** [toggle_run motor] change the state of the motor. *)
val toggle_run : tacho_motor t -> unit



(**	[emergency_stop m] force the motor [m] to stop immediatly. *)
val emergency_stop : tacho_motor t -> unit



