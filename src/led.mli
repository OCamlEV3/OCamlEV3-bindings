
(** This module handles Led on a EV3 robot. *)

module type LED_STRUCTURE = sig
  type position
  (** The type of the position. *)

  type color
  (** The type of colors. *)

  val string_of_position : position -> string
  (** [string_of_position position] translate position into a string *)

  val string_of_color : color -> string
  (** [string_of_color color] translate color into a string *)
end
(** Representation of a structure of a led.
    The representation to handle position and colorisation. By default, on a
    basic ev3 robot, it comes with two position (left and right) and two color
    (green and red) *)


module type LED_INFOS = sig
  type position
  (** Should be the same type as given on the Led Structure. *)
  
  type color
  (** Should be the same type as given on the Led Structure. *)
  
  val position : position
  (** The led position *)

  val color : color
  (** The led color *)
  
  include Device.DEVICE_INFO
end
(** Gives information about the led : what is the given position and the given
    color, its name and if multiple connection are allowed *)



module type LED_DEVICE = sig
  include Device.DEVICE
    
  val max_brightness : int
  (** This is the max brightness possible to allow. *)
  
  val min_brightness : int
  (** This is the min brightness possible to allow. *)
    
  val set_brightness : int -> unit
  (** [set_brightness i] change the brightness value of the led to [i].
      @raise Invalid_argument if [i < min_brightness] or [i > max_brightness] *)

  val get_brightness : ?force:bool -> unit -> int
  (** [get_brightness ?force ()] returns the brightness. If [force] is set to
      true then, this function will read the value into the file instead of
      the memoized value. *)

  val turn_off : unit -> unit
  (** [turn_off ()] set the brightness to [min_brightness] *)
    
  val turn_on : unit -> unit
  (** [turn_on ()] set the brightness to [max_brightness] *)
end
(** Handles a real led, allowing to change brightness of color. *)

module Make_led
    (LS : LED_STRUCTURE)
    (LI : LED_INFOS with
      type position := LS.position and type color := LS.color)
    (P : Path_finder.PATH_FINDER) : LED_DEVICE
(** Creates a led according of all informations given. *)

module LedLeftGreen  : LED_DEVICE
(** The green color of the left led. *)

module LedLeftRed    : LED_DEVICE
(** The red color of the left led. *)

module LedRightGreen : LED_DEVICE
(** The green color of the red led. *)

module LedRightRed   : LED_DEVICE
(** The red color of the red led. *)

