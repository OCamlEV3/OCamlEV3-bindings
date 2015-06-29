(**
    Implementation of a touch sensor
 *)

open Common_sensors

(** [create port] create the touch sensor *)
val create : port -> touchsensor sensors

(** [button_pressed sensor] check if [sensors] as the button pressed. *)
val button_pressed : touchsensor sensors -> bool
