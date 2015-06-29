
let command speed volume text =
  let volume = if volume > 200 then 200 else volume in
  Printf.sprintf
    "espeak --stdout -s %d -a %d \"%s\" | aplay" speed volume text

let speak ?(speed = 130) ?(volume = 150) text =
  let volume = if volume > 200 then 200 else volume in
  let c = command speed volume text
  in Sys.command c
