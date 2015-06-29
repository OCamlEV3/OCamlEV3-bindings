
open Common_sensors

type mode    = Col_reflect | Col_ambiant | Col_color | Rgb_raw

let create =
  fun port ->
    let path = find_sensor "lego-ev3-uart-29" port "" in
    ColorSensor (path, port)

let get_mode = function
  | ColorSensor (where, port) ->
    match Files.kfread @@ where ^ "mode" with
    | "COL-REFLECT" -> Col_reflect
    | "COL-AMBIANT" -> Col_ambiant
    | "COL-COLOR"   -> Col_color
    | "RGB-RAW"     -> Rgb_raw
    | _             -> assert false

let set_mode =
  fun sensor mode -> match sensor with
    | ColorSensor (where, port) ->
      Files.kfwrite (where ^ "mode") @@ match mode with
      | Col_reflect -> "COL-REFLECT"
      | Col_ambiant -> "COL-AMBIANT"
      | Col_color   -> "COL-COLOR"
      | Rgb_raw     -> "RGB-RAW"

let check_mode =
  fun sensor what ->
    if get_mode sensor <> what then raise Incorrect_mode

let get_reflected_light = function
  | ColorSensor (where, _) as s ->
    check_mode s Col_reflect;
    read_at where 0

let get_ambiant_light = function
  | ColorSensor (where, _) as s ->
    check_mode s Col_ambiant;
    read_at where 0

let get_color = function
  | ColorSensor (where, _) as s ->
    check_mode s Col_color;
    begin match read_at where 0 with
      | 0 -> None (* Unknown *)
      | 1 -> Some(Red 255, Green 255, Blue 255) (* Black  *)
      | 2 -> Some(Red   0, Green   0, Blue 255) (* Blue   *)
      | 3 -> Some(Red   0, Green 128, Blue   0) (* Green  *)
      | 4 -> Some(Red 255, Green 255, Blue   0) (* Yellow *)
      | 5 -> Some(Red 255, Green   0, Blue   0) (* Red    *)
      | 6 -> Some(Red   0, Green   0, Blue   0) (* White  *)
      | 7 -> Some(Red 165, Green  42, Blue  42) (* Brown  *)
      | _ -> assert false (* By documentation *)
    end

let get_raw_rgb = function
  | ColorSensor (where, _) as s ->
    check_mode s Rgb_raw;
    let r = read_at where in
    Red (r 0), Green (r 1), Blue (r 2)

