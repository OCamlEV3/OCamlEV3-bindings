open Common_sensors

type channel = Channel of (int * int)

type seek = channel * channel * channel * channel

type mode = Ir_prox | Ir_seek | Ir_remote

let get_mode : infraredsensor sensors -> mode = function
  | InfraredSensor (where, port) ->
    match Files.kfread @@ where ^ "mode" with
    | "IR-PROX"   -> Ir_prox
    | "IR-SEEK"   -> Ir_seek
    | "IR-REMOTE" -> Ir_remote
    | _           -> assert false

let set_mode : infraredsensor sensors -> mode -> unit =
  fun sensor mode -> match sensor with
    | InfraredSensor (where, port) ->
      Files.kfwrite (where ^ "mode") @@ match mode with
      | Ir_prox   -> "IR-PROX"
      | Ir_seek   -> "IR-SEEK"
      | Ir_remote -> "IR-REMOTE"

let check_mode : infraredsensor sensors -> mode -> unit =
  fun sensor what ->
    if get_mode sensor <> what then raise Incorrect_mode

let create : port -> infraredsensor sensors =
  fun port ->
    let path = find_sensor "lego-ev3-uart-33" port "" in
    InfraredSensor (path, port)

let get_proximity : infraredsensor sensors -> int = function
  | InfraredSensor (where, port) as s ->
    check_mode s Ir_prox;
    read_at where 0

let get_seeker : infraredsensor sensors -> seek = function
  | InfraredSensor (where, port) as s ->
    check_mode s Ir_seek;
    let r = read_at where in (
      Channel (r 0, r 1), Channel (r 2, r 3),
      Channel (r 4, r 5), Channel (r 6, r 7)
    )

let get_remote : infraredsensor sensors -> (int * int * int * int) =
  function
  | InfraredSensor (where, port) as s ->
    check_mode s Ir_remote;
    let r = read_at where in
    r 0, r 1, r 2, r 3

