
module type COMMANDS = sig
  type commands
  val string_of_command : commands -> string
end

module type MOTOR_INFOS = sig
  val output_port : Port.output_port
  val motor_name  : string
end

module type AbstractMotor = sig
  include Device.DEVICE
  include COMMANDS
  
  type polarity = Normal | Inversed
  
  val send_command : commands -> unit
  val driver_name  : unit -> string
  val duty_cycle   : unit -> int
  val duty_cycle_sp : unit -> int
  val set_duty_cycle_sp : int -> unit
  val polarity : unit -> polarity
  val set_polarity : polarity -> unit
  val state : unit -> [ `Running | `Ramping ]
  val port_name    : unit -> string
  val stop : [ `Coast | `Brake ] -> unit
  val ramp_down_sp : unit -> int
  val set_ramp_down_sp : ?valid:(int -> bool) -> int -> unit
  val ramp_up_sp : unit -> int
  val set_ramp_up_sp : ?valid:(int -> bool) -> int -> unit
  val time_sp : unit -> int
  val set_time_sp : int -> unit
end

module Make_abstract_motor
    (C : COMMANDS) (DI : Device.DEVICE_INFO)
    (P : Path_finder.PATH_FINDER) : AbstractMotor

(** {2 Tacho Motors} *)

module type TM_MOTOR_TYPE = sig

  type tm_commands =
    | RunForever
    | RunToAbsPos
    | RunToRelPos
    | RunTimed
    | RunDirect
    | Stop
    | Reset

  include AbstractMotor
    with type commands := tm_commands

  val state : unit -> [ `Running | `Ramping | `Holding | `Stalled ]
  val set_ramp_down_sp : int -> unit
  val set_ramp_up_sp : int -> unit

  val count_per_rot : unit -> int
  val encoder_polarity : unit -> polarity
  val set_encoder_polarity : polarity -> unit
  val hold_pid_d : unit -> int
  val set_hold_pid_d : int -> unit
  val hold_pid_i : unit -> int
  val set_hold_pid_i : int -> unit
  val hold_pid_p : unit -> int
  val set_hold_pid_p : int -> unit
  val position : unit -> int
  val set_position : int -> unit
  val position_sp : unit -> int
  val set_position_sp : int -> unit
  val speed : unit -> int
  val set_speed : int -> unit
  val speed_sp : unit -> int
  val set_speed_sp : int -> unit
  val speed_regulation_enabled : unit -> bool
  val set_speed_regulation : bool -> unit
  val speed_pid_d : unit -> int
  val set_speed_pid_d : int -> unit
  val speed_pid_i : unit -> int
  val set_speed_pid_i : int -> unit
  val speed_pid_p : unit -> int
  val set_speed_pid_p : int -> unit
end

module TachoMotor (DI : Device.DEVICE_INFO) (M : MOTOR_INFOS) : TM_MOTOR_TYPE

(** {2 DC Motors} *)

module type DC_MOTOR_TYPE = sig

  type dc_commands =
    | RunForever
    | RunTimed
    | Stop

  include AbstractMotor
    with type commands := dc_commands

  val set_ramp_down_sp : int -> unit
  val set_ramp_up_sp : int -> unit
  
end

module DCMotor (DI : Device.DEVICE_INFO) (M : MOTOR_INFOS) : DC_MOTOR_TYPE

  
