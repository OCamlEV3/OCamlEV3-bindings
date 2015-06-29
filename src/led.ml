
exception Incorrect_color

type position =
  | Left
  | Right

let string_of_position = function
  | Left  -> "left"
  | Right -> "right"

type color =
  | Green
  | Red
  | Amber

let string_of_color = function
  | Green -> "green"
  | Red   -> "red"
  | Amber -> raise Incorrect_color

let get_path color position =
  Printf.sprintf "/sys/class/leds/ev3:%s:%s/brightness"
    (string_of_color    color)
    (string_of_position position)

let set_color ?(brightness = 0) color position =
  let brightness = if brightness > 100 then 100 else brightness in
  let b = string_of_int brightness in
  match color with
  | Green
  | Red   ->
    Files.kfwrite (get_path color position) b
  | Amber ->
    Files.kfwrite (get_path Red   position) b;
    Files.kfwrite (get_path Green position) b

