(**
    Common functions for every sensors
 *)

(** Represents the type of touch sensor *)
type touchsensor         = TS

and  nxtcolorsensor      = NXTCS

(** Represents the type of color sensor *)
and  colorsensor         = CS

(** Represents the type of the ultrasonic sensor *)
and  nxtultrasonicsensor = NXTUS

(** Represents the type of the gyro sensor *)
and  gyrosensor          = GS

(** Represents the type of the infrared sensor *)
and  infraredsensor      = IS

(** Path to the sensor *)
and  path = string

(** The port of the sensor *)
and  port = string

(** Global sensor type *)
type _ sensors =
  | TouchSensor         : (path * port) -> touchsensor         sensors
  | ColorSensor         : (path * port) -> colorsensor         sensors
  | NXTColorSensor      : (path * port) -> nxtcolorsensor      sensors
  | NXTUltrasonicSensor : (path * port) -> nxtultrasonicsensor sensors
  | GyroSensor          : (path * port) -> gyrosensor          sensors
  | InfraredSensor      : (path * port) -> infraredsensor      sensors

type red   = Red   of int
and  green = Green of int
and  blue  = Blue  of int
and  rgb   = red * green * blue


(** [sensor_to_string sensor] return the string value of the sensor.
    In EV3, it correspond to the driver_name. *)
val sensor_to_string : 'a sensors -> string

(** Value that represent the port 1 *)
val in1 : port

(** Value that represent the port 2 *)
val in2 : port

(** Value that represent the port 3 *)
val in3 : port

(** Value that represent the port 4 *)
val in4 : port

(** Exception raised when the sensor is invalid. *)
exception Invalid_sensor of string

(** Exception raised when the driver_name is not the same. *)
exception Initialization_failed of string

(** Exception raise when the sensor mode is incorrect. *)
exception Incorrect_mode

(** [find_sensor what port address] try to find the sensor [what] at
    the port [port]. *)
val find_sensor : string -> port -> string -> string

(** Exception raised when the value is invalid. **)
exception Invalid_value of int

val read_at : string -> int -> int
