
open Device
open Path_finder

module type POWER_SUPPLY = sig
  include DEVICE
  val get_power : unit -> int
end

module Make_power_supply (DI : DEVICE_INFO) (P : PATH_FINDER) = struct
  include Make_device(DI)(P)

  let get_power () =
    action_read IO.read_int
end

module PowerSupplyInfo = struct
  let name = "power_supply"
  let multiple_connection = true
end

module PowerSupplyPathFinder =
  Path_finder.Make_absolute(struct
    let path = "/sys/class/power_supply/"
  end)

module PowerSupply =
  Make_power_supply(PowerSupplyInfo)(PowerSupplyPathFinder)
