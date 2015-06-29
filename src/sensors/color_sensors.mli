(**
    Implementation of color sensor
 *)


open Common_sensors

(** The color sensor mode *)
type mode    = Col_reflect | Col_ambiant | Col_color | Rgb_raw

(** [create port] create the port and returns a colorsensor *)
val create : port -> colorsensor sensors

(** [get_mode sensor] returns the mode of the color sensor. *)
val get_mode : colorsensor sensors -> mode

(** [set_mode sensor mode] set the mode of the color sensor. *)
val set_mode : colorsensor sensors -> mode -> unit

(** [get_reflected_light sensor] returns the reflected light. *)
val get_reflected_light : colorsensor sensors -> int

(** [get_ambiant_light sensor] returns the ambiant light. *)
val get_ambiant_light : colorsensor sensors -> int

(** [get_color sensor] returns the color expected by the sensor. *)
val get_color : colorsensor sensors -> rgb option

(** [get_raw_rgb sensor] returns the sensor as rgb. *)
val get_raw_rgb : colorsensor sensors -> rgb

