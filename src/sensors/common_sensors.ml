
type touchsensor         = TS

and  nxtcolorsensor      = NXTCS

and  colorsensor         = CS

and  nxtultrasonicsensor = NXTUS

and  gyrosensor          = GS

and  infraredsensor      = IS

and _ sensors =
  | TouchSensor         : (path * port) -> touchsensor         sensors
  | ColorSensor         : (path * port) -> colorsensor         sensors
  | NXTColorSensor      : (path * port) -> nxtcolorsensor      sensors
  | NXTUltrasonicSensor : (path * port) -> nxtultrasonicsensor sensors
  | GyroSensor          : (path * port) -> gyrosensor          sensors
  | InfraredSensor      : (path * port) -> infraredsensor      sensors

and  path = string

and  port = string

type red   = Red   of int
and  green = Green of int
and  blue  = Blue  of int
and  rgb   = red * green * blue

let sensor_to_string : type a. a sensors -> string = function
  | TouchSensor         _ -> "lego-ev3-touch"
  | ColorSensor         _ -> "ev3-uart-29"
  | NXTColorSensor      _ -> "ht-nxt-color"
  | NXTUltrasonicSensor _ -> "lego-nxt-us"
  | GyroSensor          _ -> "ev3-uart-32"
  | InfraredSensor      _ -> "ev3-uart-33"

let in1 = "in1"
let in2 = "in2"
let in3 = "in3"
let in4 = "in4"

exception Invalid_sensor of string

exception Initialization_failed of string

exception Incorrect_mode

let path = "/sys/class/lego-sensor/"

let get_path : port -> string -> string = fun port address ->
  let rec check_sensor_path = function
    | [] ->
      raise (Invalid_sensor port)

    | x :: xs ->
      let path = path ^ x ^ "/" in
      let cur_port = Files.kfread @@ (path ^ "port_name") in
      let pa = if address <> "" then port ^ ":" ^ address else port in
      if pa = cur_port then path else check_sensor_path xs
  in
  check_sensor_path @@ (Array.to_list @@ Sys.readdir path)

let find_sensor : string -> port -> string -> string =
  fun what port address ->
    let path   = get_path port address in
    let driver = path ^ "driver_name" in
    let id     = Files.kfread driver  in
    if id <> what then
      raise (Initialization_failed what)
    else
      path ^ "/"

let get_gyro_sensor : port -> gyrosensor sensors =
  fun port ->
    failwith "not implemented yet"

exception Invalid_value of int

let read_at : string -> int -> int =
  fun where v ->
    let value = Printf.sprintf "%s/value%d" where v in
    int_of_string @@ Files.kfread value

