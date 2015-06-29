
(**	Lego LED functionalities *)

(**	Exception raised when an incorret LED color id used. *)
exception Incorrect_color

(**	A LED position *)
type position =
  | Left
  | Right

(** [string_of_position p] converts the LED position [p] into
    a string. *)
val string_of_position : position -> string

(**	A LED color *)
type color =
  | Green
  | Red
  | Amber

(** [string_of_color c] converts the LED color [c] into
    a string. *)
val string_of_color : color -> string

(**	[set_color ~brightness:b c p] sets the [p] LED with the given
    color [c] and with the brightness [b]. The default brightness
    is 0. *)
val set_color : ?brightness:int -> color -> position -> unit
