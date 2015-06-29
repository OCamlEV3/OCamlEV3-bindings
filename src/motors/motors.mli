
(** Implementation of a motor *)


(** Type of tacho_motor *)
type tacho_motor = TM

(** Type of dc_motor *)
type dc_motor = DCM

(** Type of servo motor *)
type servo_motor = SM

(** Type of a motor *)
type _ t =
  | TachoMotor : mdata -> tacho_motor t
  | DCMotor : mdata -> dc_motor t
  | ServoMotor : mdata -> servo_motor t

(** Data keeped by a motor *)
and mdata = port * path

(** Different port *)
and port = OutA | OutB | OutC | OutD

(** Path to the motor *)
and path = string






(**	{3 General Motor Functionalities} *)


(**	[port_wrapper p] takes a port [p] and return the string
    corresponding to the port. *)
val port_wrapper : port -> string

(** [motor_port m] gives the port of the motor [m]. *)
val motor_port : 'a t -> string

(**	[get_file pat files] return the first file in a file list [files]
    that satisfies the regexp [pat]. *)
val get_file : Str.regexp -> string list -> string

(** [port_name m] gives the name of the port in which the motor
    [m] is pluged in *)
val port_name : 'a t -> string



(** {3 Write / Read functions} *)

(**	[read_typed_data data_of_string f m] reads the desired file [f] in
    the motort [m] and converts the resulting string through the
    [data_of_string] function. *)
val read_typed_data : (string -> 'a) -> string -> 'b t -> 'a

(**	[write_typed_data string_of_data f n m] converts the data [n] into
    a string through the [string_of_data] function and write it in the
    file [f] in the given motor [m]. *)
val write_typed_data : ('a -> string) -> string -> 'a -> 'b t -> unit


(**	[read_int f m] read an integer from a certain file [f]
    situated in the [motor]'s path.
    Raise [Failure "int_of_string"] if the data extracted from [f]
    is not an integer. *)
val read_int : string -> 'a t -> int


(**	[write_int f n m] write the integer [n] in a certain file
    [f] situated in the [motor]'s path. *)
val write_int : string -> int -> 'a t -> unit



