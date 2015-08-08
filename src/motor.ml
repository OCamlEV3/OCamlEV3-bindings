
(*
  command                   both
  commands                  both
  driver_name               both
  duty_cycle                both
  duty_cycle_sp             both
  polarity                  both
  port_name                 both
  ramp_up_sp                both
  ramp_down_sp              both
  state                     both
  stop_command              both
  stop_commands             both
  time_sp                   both
  count_per_rot             tacho
  encoder_polarity          tacho
  position                  tacho
  hold_pid/Kd               tacho
  hold_pid/Ki               tacho
  hold_pid/Kp               tacho
  position_sp               tacho
  speed                     tacho
  speed_sp                  tacho
  speed_regulation          tacho
  speed_pid/Kd              tacho
  speed_pid/Ki              tacho
  speed_pid/Kp              tacho
*)

open Device
open Path_finder
open Port

let invalid_value device_name kind value =
  raise (Invalid_value
          (Printf.sprintf "%s:%s:%s" device_name kind value))

module type COMMANDS = sig
  type commands
  val string_of_command : commands -> string
end

module type MOTOR_INFOS = sig
  val output_port : output_port
  val motor_name  : string
end

module type AbstractMotor = sig
  include DEVICE
  include COMMANDS

  type polarity = Normal | Inversed
  
  val send_command : commands -> unit
  val driver_name : unit -> string
  val duty_cycle : unit -> int
  val duty_cycle_sp : unit -> int
  val set_duty_cycle_sp : int -> unit
  val polarity : unit -> polarity
  val set_polarity : polarity -> unit
  val state : unit -> [ `Running | `Ramping ]
  val port_name : unit -> string
  val stop : [ `Coast | `Brake ] -> unit
  val ramp_down_sp : unit -> int
  val set_ramp_down_sp : ?valid:(int -> bool) -> int -> unit
  val ramp_up_sp : unit -> int
  val set_ramp_up_sp : ?valid:(int -> bool) -> int -> unit
  val time_sp : unit -> int
  val set_time_sp : int -> unit
end

module Make_abstract_motor
    (C : COMMANDS) (DI : DEVICE_INFO) (P : PATH_FINDER) =
struct

  include Make_device(DI)(P)

  include C

  type polarity = Normal | Inversed

  let read_polarity = action_read (IO.mk_reader (function
      | "normal" -> Normal
      | "inversed" -> Inversed
      | _ -> assert false
    ))
  let write_command  = action_write (IO.mk_writer string_of_command)
  let write_polarity =
    action_write (IO.mk_writer (fun polarity ->
        match polarity with
        | Normal   -> "normal"
        | Inversed -> "inversed"
      ))
  
  let send_command cmd =
    write_command cmd "command"

  let driver_name () =
    action_read_string "driver_name"

  let duty_cycle () =
    action_read_int "duty_cycle"
    
  let duty_cycle_sp () =
    action_read_int "duty_cycle_sp"
    
  let set_duty_cycle_sp i =
    if i < (-100) || i > 100 then
      invalid_value DI.name "set_duty_cycle_sp" (string_of_int i);
    action_write_int i "duty_cycle_sp"
      
  let polarity () =
    read_polarity "polarity"

  let set_polarity p =
    write_polarity p "polarity"

  let state () =
    match action_read_string "state" with
    | "running" -> `Running
    | "ramping" -> `Ramping
    | _ -> assert false

  let port_name () =
    action_read_string "port_name"

  let stop s =
    let action = match s with
      | `Coast -> "coast"
      | `Brake -> "brake"
    in
    action_write_string action "stop"

  let ramp_down_sp () =
    action_read_int "ramp_down_sp"

  let set_ramp_down_sp ?(valid = fun _ -> true) i =
    if not (valid i) then
      invalid_value DI.name "set_ramp_down_sp" (string_of_int i);
    action_write_int i "ramp_down_sp"

  let ramp_up_sp () =
    action_read_int "ramp_up_sp"

  let set_ramp_up_sp ?(valid = fun _ -> true) i =
    if not (valid i) then
      invalid_value DI.name "set_ramp_up_sp" (string_of_int i);
    action_write_int i "ramp_up_sp"

  let time_sp () =
    action_read_int "time_sp"

  let set_time_sp i =
    action_write_int i "time_sp"

end

(* TACHO MOTOR PART *)

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


module TachoMotor (DI : DEVICE_INFO) (M : MOTOR_INFOS) = struct

  type tm_commands =
    | RunForever
    | RunToAbsPos
    | RunToRelPos
    | RunTimed
    | RunDirect
    | Stop
    | Reset
 
  module TMMotorCommands = struct
    type commands = tm_commands
    let string_of_command = function
      | RunForever  -> "run-forever"
      | RunToAbsPos -> "run-to-abs-pos"
      | RunToRelPos -> "run-to-rel-pos"
      | RunTimed    -> "run-timed"
      | RunDirect   -> "run-direct"
      | Stop        -> "stop"
      | Reset       -> "reset"
  end
  
  module TMMotorPathFinder = Path_finder.Make(struct
      let prefix = "/sys/class/tacho-motor/" 
      let conditions = [
        ("name", M.motor_name);
        ("port", string_of_output_port M.output_port);
      ]
    end)
  
  include Make_abstract_motor
      (TMMotorCommands)(DI)(TMMotorPathFinder)


  let write_bool =
    action_write (IO.mk_writer (fun x -> if x then "on" else "off"))

  let read_bool =
    action_read (IO.mk_reader (function
        | "on"  -> true
        | "off" -> false
        | _ -> assert false
      ))

  let state () =
    match action_read_string "state" with
    | "running" -> `Running
    | "ramping" -> `Ramping
    | "holding" -> `Holding
    | "stalled" -> `Stalled
    | _ -> assert false

  let set_ramp_up_sp = set_ramp_up_sp ~valid:(( <= ) 0)
  let set_ramp_down_sp = set_ramp_down_sp ~valid:(( <= ) 0)

  let count_per_rot () =
    action_read_int "count_per_rot"
      
  let encoder_polarity () =
    read_polarity "encoder_polarity"
    
  let set_encoder_polarity polarity =
    write_polarity polarity "encoder_polarity"
      
  let hold_pid_d () =
    action_read_int "hold_pid/Kd"

  let set_hold_pid_d i =
    action_write_int i "hold_pid/Kd"

  let hold_pid_i () =
    action_read_int "hold_pid/Ki"
      
  let set_hold_pid_i i =
    action_write_int i "hold_pid/Ki"

  let hold_pid_p () =
    action_read_int "hold_pid/Kp"
      
  let set_hold_pid_p i =
    action_write_int i "hold_pid/Kp"

  let position () =
    action_read_int "position"
      
  let set_position i =
    action_write_int i "position"

  let position_sp () =
    action_read_int "position_sp"

  let set_position_sp i =
    action_write_int i "position_sp"

  let speed () =
    action_read_int "speed"

  let set_speed i =
    action_write_int i "speed"
      
  let speed_sp () =
    action_read_int "speed_sp"

  let set_speed_sp i =
    action_write_int i "speed_sp"
      
  let speed_regulation_enabled () =
    read_bool "speed_regulation"

  let set_speed_regulation b =
    write_bool b "speed_regulation"

  let speed_pid_d () =
    action_read_int "speed_pid/Kd"

  let set_speed_pid_d i =
    action_write_int i "speed_pid/Kd"

  let speed_pid_i () =
    action_read_int "speed_pid/Ki"

  let set_speed_pid_i i =
    action_write_int i "speed_pid/Ki"

  let speed_pid_p () =
    action_read_int "speed_pid/Kp"

  let set_speed_pid_p i =
    action_write_int i "speed_pid/Kp"

end





(* DC MOTOR *)


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

module DCMotor (DI : DEVICE_INFO) (M : MOTOR_INFOS) = struct

  type dc_commands =
    | RunForever
    | RunTimed
    | Stop
  
  type dc_state =
    | Running
    | Ramping
        
  module DCMotorCommands = struct
    type commands = dc_commands
    let string_of_command = function
      | RunForever -> "run-forever"
      | RunTimed   -> "run-timed"
      | Stop       -> "stop"
  end

  
  module DCState = struct
    type state = dc_state
    let state_of_string = function
      | "running" -> Running
      | "ramping" -> Ramping
      | _ -> assert false
  end
  
  module DCMotorPathFinder = Path_finder.Make(struct
      let prefix = "/sys/class/dc-motor/"
      let conditions = [
        ("name", M.motor_name);
        ("port", string_of_output_port M.output_port
        );
      ]
    end)
  
  include Make_abstract_motor
      (DCMotorCommands)(DI)(DCMotorPathFinder)

  let set_ramp_up_sp =
    set_ramp_up_sp ~valid:(fun x -> x >= 0 && x <= 10000)

  let set_ramp_down_sp =
    set_ramp_down_sp ~valid:(fun x -> x >= 0 && x <= 10000)

end

