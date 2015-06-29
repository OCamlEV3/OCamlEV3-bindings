(** Nxt Ultrasonic Sensor *)

open Common_sensors

type mode = US_DIST_CM | US_DIST_IN | US_SI_CM | US_SI_IN | US_LISTEN

(** [create port] create the port and returns a nxtultrasonicsensor *)
val create : port -> nxtultrasonicsensor sensors

(** [get_mode sensor] returns the mode of the nxtultrasonicsensor. *)
val get_mode : nxtultrasonicsensor sensors -> mode

(** [set_mode sensor mode] set the mode of the nxtultrasonicsensor. *)
val set_mode : nxtultrasonicsensor sensors -> mode -> unit

val get_cont_measurement_cm : nxtultrasonicsensor sensors -> int

val get_cont_measurement_inch : nxtultrasonicsensor sensors -> int

val get_in_measurement_cm : nxtultrasonicsensor sensors -> int

val get_in_measurement_inch : nxtultrasonicsensor sensors -> int

val listen : nxtultrasonicsensor sensors -> int
