

type tacho_motor = TM
type dc_motor = DCM
type servo_motor = SM

type _ t =
  | TachoMotor : mdata -> tacho_motor t
  | DCMotor : mdata -> dc_motor t
  | ServoMotor : mdata -> servo_motor t

and mdata = port * path

and port = OutA | OutB | OutC | OutD

and path = string








(* General Motor Functionalities *)


let port_wrapper = function
  | OutA -> "outA"
  | OutB -> "outB"
  | OutC -> "outC"
  | OutD -> "outD"

let motor_port : type a. a t -> string = function
  | TachoMotor (p, _) ->
    port_wrapper p
  | DCMotor (p, _) ->
    port_wrapper p
  | ServoMotor (p, _) ->
    port_wrapper p

let motor_path : type a. a t -> path = function
  | TachoMotor (_, a) -> a
  | DCMotor (_, a) -> a
  | ServoMotor (_, a) -> a

let rec get_file pattern = function
  | file::l ->
    if Str.string_match pattern file 0 then
      file
    else
      get_file pattern l
  | [] -> raise Not_found

let port_name = motor_port




(* Write / Read functions *)

let read_typed_data data_of_string file motor =
  Files.kfread (motor_path motor ^ file) |> data_of_string

let write_typed_data string_of_data file n motor =
  string_of_data n |> Files.kfwrite (motor_path motor ^ file)

let read_int f m = read_typed_data int_of_string f m

let write_int f n m= write_typed_data string_of_int f n m







