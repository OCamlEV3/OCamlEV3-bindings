open Common_sensors

let create : port -> touchsensor sensors =
  fun port ->
    let path = find_sensor "lego-ev3-touch" port "" in
    TouchSensor (path, port)

let button_pressed : touchsensor sensors -> bool =
  fun s -> match s with
  | TouchSensor (where, _) ->
      read_at where 0 = 1

  (* TODO: ERROR MESSAGE *)
