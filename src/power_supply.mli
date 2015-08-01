

(** Provides an interface to use power supply of an EV3 robot. *)

open Device
open Path_finder

(** Defintition of a power supply device *)
module type POWER_SUPPLY = sig

  include DEVICE

  val get_power : unit -> int
  (** [get_power ()] returns the power as an integer of the robot. *)
  
end

(** Create a power supply according to his path. *)
module Make_power_supply (P : PATH_FINDER) : POWER_SUPPLY

(** The default power supply module *)
module DefaultPowerSupply : POWER_SUPPLY
