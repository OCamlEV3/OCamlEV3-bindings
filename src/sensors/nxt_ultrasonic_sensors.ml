
open Common_sensors

type mode = US_DIST_CM | US_DIST_IN | US_SI_CM | US_SI_IN | US_LISTEN

let create =
  fun port ->
    let path = find_sensor "lego-nxt-us" port "i2c1" in
    NXTUltrasonicSensor (path, port)

let get_mode = function
  | NXTUltrasonicSensor (where, port) ->
    match Files.kfread @@ where ^ "mode" with
    | "US-DIST-CM" -> US_DIST_CM
    | "US-DIST-IN" -> US_DIST_IN
    | "US-SI-CM"   -> US_SI_CM
    | "US-SI-IN"   -> US_SI_IN
    | "US-LISTEN"  -> US_LISTEN
    | _            -> assert false

let set_mode =
  fun sensor mode -> match sensor with
    | NXTUltrasonicSensor (where, port) ->
        Files.kfwrite (where ^ "mode") @@ match mode with
        | US_DIST_CM -> "US-DIST-CM"
        | US_DIST_IN -> "US-DIST-IN"
        | US_SI_CM   -> "US-SI-CM"
        | US_SI_IN   -> "US-SI-IN"
        | US_LISTEN  -> "US-LISTEN"

let check_mode =
  fun sensor what ->
    if get_mode sensor <> what then raise Incorrect_mode

let get_cont_measurement_cm = function
  | NXTUltrasonicSensor (where, _) as s ->
    check_mode s US_DIST_CM;
    read_at where 0

let get_cont_measurement_inch = function
  | NXTUltrasonicSensor (where, _) as s ->
    check_mode s US_DIST_IN;
    read_at where 0

let get_in_measurement_cm = function
  | NXTUltrasonicSensor (where, _) as s ->
    check_mode s US_SI_CM;
    read_at where 0

let get_in_measurement_inch = function
  | NXTUltrasonicSensor (where, _) as s ->
    check_mode s US_SI_IN;
    read_at where 0

let listen = function
  | NXTUltrasonicSensor (where, _) as s ->
    check_mode s US_LISTEN;
    read_at where 0
