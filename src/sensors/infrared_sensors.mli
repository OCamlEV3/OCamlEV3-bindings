(**
    Implementation of infrared sensor
 *)

open Common_sensors

(** Represent the type of the channel *)
type channel = Channel of (int * int)

(** Type of the seeker *)
type seek = channel * channel * channel * channel

(** Type of the infrared sensor *)
type mode = Ir_prox | Ir_seek | Ir_remote

(** [get_mode sensor] return the mode of the infrared sensor *)
val get_mode : infraredsensor sensors -> mode

(** [set_mode sensor mode] set the mode *)
val set_mode : infraredsensor sensors -> mode -> unit

(** [create port] create the infrared sensor at [port]. *)
val create : port -> infraredsensor sensors

(** [get_proximity sensor] return the proximity value *)
val get_proximity : infraredsensor sensors -> int

(** [get_seeker sensor] return the seek value *)
val get_seeker : infraredsensor sensors -> seek

(** [get_remote sensor] return the remote value *)
val get_remote : infraredsensor sensors -> (int * int * int * int)

