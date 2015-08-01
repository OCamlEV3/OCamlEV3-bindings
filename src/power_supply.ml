
open Device
open Path_finder

module type POWER_SUPPLY = sig
  include DEVICE
  val get_power : unit -> int
end

module Make_power_supply (P : PATH_FINDER) = struct
  include Make_device(struct
      let name = "power_supply"
      let multiple_connection = true
    end)(P)

  let get_power () =
    action_read IO.read_int
end

module DefaultPowerSupply =
  Make_power_supply(
    Path_finder.Make_absolute(struct
      let path = "/sys/class/power_supply/"
    end)
  )
