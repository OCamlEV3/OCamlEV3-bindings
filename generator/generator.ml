
(*****************************************************************************)
(* The MIT License (MIT)                                                     *)
(*                                                                           *)
(* Copyright (c) 2015 OCamlEV3                                               *)
(*  Loïc Runarvot <loic.runarvot[at]gmail.com>                               *)
(*  Nicolas Tortrat-Gentilhomme <nicolas.tortrat[at]gmail.com>               *)
(*  Nicolas Raymond <noci.64[at]orange.fr>                                   *)
(*                                                                           *)
(* Permission is hereby granted, free of charge, to any person obtaining a   *)
(* copy of this software and associated documentation files (the "Software"),*)
(* to deal in the Software without restriction, including without limitation *)
(* the rights to use, copy, modify, merge, publish, distribute, sublicense,  *)
(* and/or sell copies of the Software, and to permit persons to whom the     *)
(* Software is furnished to do so, subject to the following conditions:      *)
(*                                                                           *)
(* The above copyright notice and this permission notice shall be included   *)
(* in all copies or substantial portions of the Software.                    *)
(*                                                                           *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS   *)
(* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF                *)
(* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.    *)
(* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY      *)
(* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT *)
(* OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR  *)
(* THE USE OR OTHER DEALINGS IN THE SOFTWARE.                                *)
(*****************************************************************************)

open String
open Yojson

type sensor = {
  name : string option;
  driver_name : string option;
  modes : (string * string * int) list;
}

let empty_sensor = {
  name = None;
  driver_name = None;
  modes = [];
}

let the = function
  | None -> assert false
  | Some s -> s

(*

   Parsing the JSON to create the structure.

*)

let extract_string key = function
  | `String s -> Some s
  | _ -> failwith ("Expect a string for key '" ^ key ^ "'")

let sensor_of_association assocs =
  let rec aux sensor = function
    | [] -> sensor
    | (left, right) :: xs ->
      match left with
      | "name" ->
        aux { sensor with name = (extract_string "name" right) } xs

      | "driver_name" ->
        aux { sensor with driver_name = (extract_string "driver_name" right)} xs

      | "modes" ->
        let mode assoc =
          match assoc with
          | `Assoc ([
              ("mode", `String mmode);
              ("name", `String mname);
              ("nb", `Int i)
            ]) ->
            (mmode, mname, i)
          | _ -> failwith "A mode must be {mode:string,name:string,nb:int}"
        in
        let modes =
          begin match right with
          | (`Assoc _) as assoc -> [mode assoc]
          | `List l -> List.map mode l 
          | _ -> failwith "For 'modes' key, only expects an assoc or a list."
          end
        in
        aux { sensor with modes } xs

      | x -> failwith ("Unknown key '" ^ x ^ "'")
  in
  aux empty_sensor assocs

let parse path =
  let json = Safe.from_file path in
  match json with
  | `Assoc assocs -> [sensor_of_association assocs]
  | `List l -> List.map (fun x ->
      match x with
      | `Assoc assocs -> sensor_of_association assocs
      | _ -> failwith "On top-level list, expects only associations."
    ) l
  | _ -> failwith "On top-level, expects list or association."


(*

   Generate all the .ml and .mli files

*)

(* Generation helper *)
let modifier stringf regex modifier what =
  stringf (Str.(global_replace (regexp regex) modifier) what)

let type_of_nb = function
  | 1 -> "int ufun"
  | n -> Printf.sprintf "int_tuple%d ufun" n

let function_of_nb nb =
  Printf.sprintf "checked_read read%d" nb

let fp = Format.fprintf
(* * *)
           

let write_opens fmt opens =
  List.iter (fp fmt "@[open %s@]@\n") opens

let write_constructor fmt (constructor, doc) =
  fp fmt "@\n| %s" constructor;
  if doc then fp fmt "@ (** Constructor for %s mode. *)" constructor
  
let write_constructors fmt (constructors, doc) =
  List.iter (fun x -> write_constructor fmt (x, doc)) constructors

let write_type_modes fmt (type_modes, ctors, doc) =
  fp fmt "@[<hov 2>type %s = %a@]"
    type_modes write_constructors (ctors, doc);
  if doc then
    fp fmt "@\n(** Type for modes of the sensor %s. *)@\n@\n"
      type_modes
  else
    fp fmt "@\n@\n"

let write_vals fmt (vals, doc) =
  List.iter (fun (fname, nb) ->
      fp fmt "@\nval %s : %s" fname (type_of_nb nb);
      if doc then
        fp fmt "@\n(** [%s ()] returns the \
                current value of the mode %s *)@\n" fname fname
    ) vals

let write_include_abstract_sensor fmt type_modes =
  fp fmt "@[<hov 2>include AbstractSensor@\n";
  fp fmt "with type commands := unit@\n";
  fp fmt " and type modes    := %s@]@\n" type_modes

let write_module_type
    fmt (module_type_name, type_modes, informations, doc) =
  let ctors = List.map (fun (_, x, _, _) -> x) informations in
  let vals  = List.map (fun (_, _, x, y) -> (x, y)) informations in
  fp fmt
    "@\n@[<hov 2>module type %s = sig@\n@\n%a%a%a@]@\nend@\n@\n"
    module_type_name
    write_type_modes (type_modes, ctors, doc)
    write_include_abstract_sensor type_modes
    write_vals (vals, doc)

let write_pattern_matching fmt (left, right) =
  List.iter2 (fp fmt "@\n| %s -> %s") left right

let write_of_string fmt (name, left, right) =
  let left = List.map (fun x -> Printf.sprintf "\"%s\"" x) left in
  fp fmt "@\n@[<hov 2>let %s_of_string = function%a\
          @\n| _ -> assert false@]@\n"
    name write_pattern_matching (left, right)

let write_to_string fmt (name, left, right) =
  let right = List.map (fun x -> Printf.sprintf "\"%s\"" x) right in
  fp fmt "@\n@[<hov 2>let string_of_%s = function%a@]@\n"
    name write_pattern_matching (left, right)

(* The module implementation writer for ML files. *)
let write_module_ml fmt name driver_name module_mode
    path_mode type_modes informations =
  let write_functor fmt functors =
    List.iter (fun (x, y) -> fp fmt "@ (%s : %s)" x y) functors
  in
  let write_module_mode fmt (ns, cs) =
    fp fmt
      "@\n@\n@[<hov 2>module %s = struct@\ntype modes = %s@\n%a%a\
       @\nlet default_mode = %s@]@\nend"
      module_mode type_modes
      write_of_string ("modes", ns, cs)
      write_to_string ("modes", cs, ns)
      (List.hd cs)
  in
  let write_path_maker fmt =
    fp fmt "@\n@[<hov 2>module %s = Path_finder.Make(struct@\n\
            @[let prefix = \"/sys/class/lego-sensor\"@]@\n\
            @[<hov 2>let conditions = [\
            @\n(\"name\", \"%s\");\
            @\n(\"port\", string_of_output_port P.output_port)\
            @]@\n]\
            @]@\nend)@\n"
      path_mode driver_name;
  in
  let write_includes fmt =
    fp fmt "@\n@[<hov 2>include Make_abstract_sensor(struct@\n\
            type commands = unit@\n\
            let string_of_commands () = assert false@]@\n\
            end)(%s)(DI)(%s)@\n"
      module_mode path_mode
  in
  let write_lets fmt vals =
    List.iter (fun (c, fn, n) ->
        fp fmt "@\n@[let %s = %s@ %s@]" fn (function_of_nb n) c
      ) vals
  in

  let names = List.map (fun (n, _, _, _) -> n) informations in
  let ctors = List.map (fun (_, c, _, _) -> c) informations in
  let lets  = List.map (fun (_, c, fn, n) -> (c, fn, n)) informations in
  
  fp fmt
    "@\n@[<hov 2>module %s%a = struct@\n@\n%a%a@\n%t%t%a@]@\nend@\n@\n"
    name
    write_functor [("DI", "DEVICE_INFO"); ("P", "OUTPUT_PORT")]
    write_type_modes (type_modes, ctors, false)
    write_module_mode (names, ctors)
    write_path_maker
    write_includes
    write_lets lets

(* The module implementation writer on MLI file. *)
let write_module_mli fmt name module_name module_type_name =
  fp fmt "@[module %s (DI : DEVICE_INFO) (P: OUTPUT_PORT) : %s@]@\n"
    module_name module_type_name;
  fp fmt "@[(** Implementation of %s. *)@]@\n" name

let write_license fmt =
  fp fmt
    "(*****************************************************************************)@\n\
     (* The MIT License (MIT)                                                     *)@\n\
     (*                                                                           *)@\n\
     (* Copyright (c) 2015 OCamlEV3                                               *)@\n\
     (*  Loïc Runarvot <loic.runarvot[at]gmail.com>                               *)@\n\
     (*  Nicolas Tortrat-Gentilhomme <nicolas.tortrat[at]gmail.com>               *)@\n\
     (*  Nicolas Raymond <noci.64[at]orange.fr>                                   *)@\n\
     (*                                                                           *)@\n\
     (* Permission is hereby granted, free of charge, to any person obtaining a   *)@\n\
     (* copy of this software and associated documentation files (the \"Software\"),*)@\n\
     (* to deal in the Software without restriction, including without limitation *)@\n\
     (* the rights to use, copy, modify, merge, publish, distribute, sublicense,  *)@\n\
     (* and/or sell copies of the Software, and to permit persons to whom the     *)@\n\
     (* Software is furnished to do so, subject to the following conditions:      *)@\n\
     (*                                                                           *)@\n\
     (* The above copyright notice and this permission notice shall be included   *)@\n\
     (* in all copies or substantial portions of the Software.                    *)@\n\
     (*                                                                           *)@\n\
     (* THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS   *)@\n\
     (* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF                *)@\n\
     (* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.    *)@\n\
     (* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY      *)@\n\
     (* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT *)@\n\
     (* OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR  *)@\n\
     (* THE USE OR OTHER DEALINGS IN THE SOFTWARE.                                *)@\n\
     (*****************************************************************************)@\n@\n"

let write_compilation_flag fmt =
  fp fmt "@[(*@\n\
          Local Variables:@\n\
          compile-command: \"make -C ../..\"@\n\
          End:@\n\
          *)@]@\n"

let generate_sensor sensor where =
  let name = the sensor.name in
  let pretty_name = modifier capitalize "[A-Z]" " \\0" name in
  let module_name = modifier capitalize "" "" name in
  let module_type_name = modifier uppercase "[A-Z]" "_\\0" name in
  let type_modes = modifier lowercase "[A-Z]" "_\\0" name ^ "_modes" in
  let module_modes = module_name ^ "Modes" in
  let path_finder = module_name ^ "PathFinder" in
  let modes_informations =
    List.map (fun (mode, name, nb) ->
        let ctor = modifier uppercase "-" "_" mode in
        let fname = modifier lowercase " " "_" name in
        mode, (* The str-value : kind-like-this *)
        ctor, (* constructor : KIND_LIKE_THIS *)
        fname, (* fname : kind_like_this *)
        nb
      ) sensor.modes
  in
  
  let mlbuffer  = Buffer.create 42 in
  let mlibuffer = Buffer.create 42 in
  let mlfmt  = Format.formatter_of_buffer mlbuffer  in
  let mlifmt = Format.formatter_of_buffer mlibuffer in

  let write_on_both f x =
    List.iter (fun fmt -> fp fmt "%a" f x) [mlfmt; mlifmt]
  in
  let write_on_both_t f =
    List.iter (fun fmt -> fp fmt "%t" f) [mlfmt; mlifmt]
  in

  write_on_both_t (fun fmt -> fp fmt "@\n@[");

  (* Licenses *)
  write_on_both_t write_license;
  
  (* Opens *)
  write_on_both write_opens [ "Device"; "Port"; "Sensor" ];

  (* Module type *)
  let module_type doc =
    (module_type_name, type_modes, modes_informations, doc)
  in
  write_module_type mlfmt  (module_type false);
  write_module_type mlifmt (module_type true);

  (* Module implementation *)
  write_module_ml mlfmt module_name (the sensor.driver_name)
    module_modes path_finder type_modes modes_informations;
  write_module_mli mlifmt pretty_name module_name module_type_name;
  
  write_on_both (fun fmt -> fp fmt "@]@\n%t@.") write_compilation_flag;
  (Buffer.to_bytes mlbuffer, Buffer.to_bytes mlibuffer)

let generate sensors where =
  let write_buffer name ext buffer =
    let chan = open_out (Filename.concat where (name ^ ext)) in
    output_string chan buffer;
    close_out chan
  in
    
  List.iter (fun x ->
      let (ml, mli) = generate_sensor x where in
      let name = the x.name in
      write_buffer name ".ml" ml;
      write_buffer name ".mli" mli
    ) sensors

let () =
  generate (parse "sensors.json") "../src/sensors/"


(*
Local Variables:
compile-command: "make"
End:
*)
