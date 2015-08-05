

(** Provides an interface to use power supply of an EV3 robot. *)

open Device
open Path_finder

module type POWER_SUPPLY = sig

  include DEVICE

  val get_power : unit -> int
  (** [get_power ()] returns the power as an integer of the robot. *)
  
end
(** Definition of a power supply device *)


module Make_power_supply (DI : DEVICE_INFO) (P : PATH_FINDER) : POWER_SUPPLY
(** Create a power supply according to his path. *)

module PowerSupply : POWER_SUPPLY
(** The default power supply module binded to the path given on the standard
    documentation of ev3dev *)
