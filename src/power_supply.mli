
open Core
open Device

module type POWER_SUPPLY = sig
  include DEVICE
  val get_power : unit -> int m
end

module PowerSupply : POWER_SUPPLY
module PowerSupplyLwt : POWER_SUPPLY with type 'a m = 'a Lwt.t
