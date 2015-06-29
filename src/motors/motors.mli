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



