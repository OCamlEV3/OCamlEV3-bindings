
open Device
open Path_finder

exception IncorrectMode of string

type 'a ufun = unit -> 'a  
type int_tuple2  = int * int
type int_tuple3  = int * int * int
type int_tuple4  = int * int * int * int
type int_tuple5  = int * int * int * int * int
type int_tuple6  = int * int * int * int * int * int
type int_tuple7  = int * int * int * int * int * int * int
type int_tuple8  = int * int * int * int * int * int * int * int
type int_tuple9  = int * int * int * int * int * int * int * int * int
type int_tuple10 = int * int * int * int * int * int * int * int * int * int


module type COMMANDS = sig
  type commands
  val string_of_commands : commands -> string
end

module type MODES = sig
  type modes
  val string_of_modes : modes -> string
  val modes_of_string : string -> modes
  val default_mode    : modes
end

module type AbstractSensor = sig

  include DEVICE
  include COMMANDS
  include MODES

  val set_mode : modes -> unit
  val get_mode : unit -> modes

  val automatically_change_mode : unit -> unit
  
  val value0 : int ufun
  val value1 : int ufun
  val value2 : int ufun
  val value3 : int ufun
  val value4 : int ufun
  val value5 : int ufun
  val value6 : int ufun
  val value7 : int ufun
  val value8 : int ufun
  val value9 : int ufun

  val read1  : int ufun
  val read2  : int_tuple2 ufun
  val read3  : int_tuple3 ufun
  val read4  : int_tuple4 ufun
  val read5  : int_tuple5 ufun
  val read6  : int_tuple6 ufun
  val read7  : int_tuple7 ufun
  val read8  : int_tuple8 ufun
  val read9  : int_tuple9 ufun
  val read10 : int_tuple10 ufun

  val checked_read : (unit -> 'a) -> modes -> unit -> 'a
end

module Make_abstract_sensor
    (C : COMMANDS) (M : MODES) (DI : DEVICE_INFO) (P : PATH_FINDER) =
struct

  include Make_device(DI)(P)
  
  include C

  include M

  type 'a mfun = modes -> unit -> 'a
  
  let current_mode = ref default_mode
  let set_mode m = assert false
  let get_mode () = assert false

  let change_mode = ref false
  let automatically_change_mode () = change_mode := not !change_mode
 
  let value_n i =
    assert false

  let value0 () = value_n 0
  let value1 () = value_n 1
  let value2 () = value_n 2
  let value3 () = value_n 3
  let value4 () = value_n 4
  let value5 () = value_n 5
  let value6 () = value_n 6
  let value7 () = value_n 7
  let value8 () = value_n 8
  let value9 () = value_n 9

  let check_mode expected_mode =
    if get_mode () <> expected_mode then begin
      if !change_mode then
        set_mode expected_mode
      else
        raise (IncorrectMode
                 (Printf.sprintf "Current: %s; Expected %s"
                    (string_of_modes (get_mode ()))
                    (string_of_modes expected_mode)))
    end

  
  let read1 () =
    value0 ()

  let read2 () =
    value0 (), value1 ()

  let read3 () =
    value0 (), value1 (), value2 ()

  let read4 () =
    value0 (), value1 (), value2 (), value3 ()

  let read5 () =
    value0 (), value1 (), value2 (), value3 (), value4 ()

  let read6 () =
    value0 (), value1 (), value2 (), value3 (), value4 (), value5 ()

  let read7 () =
    value0 (), value1 (), value2 (), value3 (), value4 (), value5 (),
    value6 ()

  let read8 () =
    value0 (), value1 (), value2 (), value3 (), value4 (), value5 (),
    value6 (), value7 ()

  let read9 () =
    value0 (), value1 (), value2 (), value3 (), value4 (), value5 (),
    value6 (), value7 (), value8 ()

  let read10 () =
    value0 (), value1 (), value2 (), value3 (), value4 (), value5 (),
    value6 (), value7 (), value8 (), value9 ()

  let checked_read f m = check_mode m; (fun () -> f ())
end

