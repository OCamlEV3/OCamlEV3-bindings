(** Implementation of a NXT Color Sensor *)

open Common_sensors

(** White component *)
type white = White of int

(** Values return by the sensor *)
type values =
  white * rgb

(** The mode of the NXT Color Sensor. *)
type mode =
  | NXT_Col_color
  (** Color mode. One value between 0 and 17. *)
  | NXT_Col_red
  (** Red component. One value between 0 and 255. *)
  | NXT_Col_green
  (** Green component. One value between 0 and 255. *)
  | NXT_Col_blue
  (** Blue component. One value between 0 and 255. *)
  | NXT_Col_white
  (** White component. One value between 0 and 255. *)
  | NXT_Col_norm
  (** Normalized component. *)
  | NXT_Col_all
  (** All colors. Three value (RGB) with values between 0 and 255. *)
  | NXT_Col_raw
  (** Raw colors. Three value (RGB) with values between 0 and 255. *)

(** [create port] create the port and returns a nxtcolorsensor *)
val create : port -> nxtcolorsensor sensors

(** [get_mode sensor] returns the mode of the color sensor. *)
val get_mode : nxtcolorsensor sensors -> mode

(** [set_mode sensor mode] set the mode of the color sensor. *)
val set_mode : nxtcolorsensor sensors -> mode -> unit

(** [get_color sensor] returns the color value of [sensor]. *)
val get_color : nxtcolorsensor sensors -> int

(** [get_component what sensor] return the correct component value. *)
val get_component :
  [< `Red | `Blue | `Green | `White ] -> nxtcolorsensor sensors -> int

(** [get_norm sensor] returns the normalized rgb color of [sensor]. *)
val get_norm : nxtcolorsensor sensors -> values

(** [get_raw_rgb sensor] returns the rgb color of [sensor]. *)
val get_raw_rgb : nxtcolorsensor sensors -> values

(** [get_all sensor] returns the color and the rgb color of [sensor]. *)
val get_all : nxtcolorsensor sensors -> values
