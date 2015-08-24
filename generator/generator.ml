
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
  path : string;
  name : string option;
  driver_name : string option;
  modes : (string * string * int) list;
  link : string option;
  commands : string list;
}

let empty_sensor = {
  path = "";
  name = None;
  driver_name = None;
  modes = [];
  link = None;
  commands = [];
}

let the = function
  | None -> assert false
  | Some s -> s

(*

   Parsing the JSON to create the structure.

*)

let extract_string key = function
  | `String s -> (s : string)
  | _ -> failwith ("Expect a string for key '" ^ key ^ "'")

let sensor_of_association assocs sensor =
  let rec aux sensor = function
    | [] -> sensor
    | (left, right) :: xs ->
      match left with
      | "name" ->
        aux { sensor with name = Some (extract_string "name" right) } xs

      | "driver_name" ->
        aux { sensor with
              driver_name = Some (extract_string "driver_name" right) } xs

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

      | "link" ->
        aux { sensor with link = Some (extract_string "link" right) } xs

      | "commands" ->
        let commands = 
          begin match right with
          | `String s -> [s]
          | `List l   -> List.map (extract_string "commands") l
          | _ -> failwith "Expected string or list after commands."
          end
        in
        aux { sensor with commands } xs

      | x -> failwith ("Unknown key '" ^ x ^ "'")
  in
  aux sensor assocs

let sensor_of_json = function
  | [("folder", `String path); ("sensors", sensors)] ->
    let sensor = { empty_sensor with path } in
    begin match sensors with
    | `Assoc assocs ->
      [sensor_of_association assocs sensor]
    | `List l ->
      List.map (fun s ->
          match s with
          | `Assoc assocs ->
            sensor_of_association assocs sensor
          | _ ->
            failwith "Expect Assoc"
        ) l
    | _ ->
      failwith "Expect Assoc or List."
    end
  | _ ->
    failwith "Malformed"

let parse path =
  let json = Safe.from_file path in
  match json with
  | `Assoc assocs ->
    sensor_of_json assocs
  | `List l -> List.(flatten (map (fun x ->
      match x with
      | `Assoc assocs -> sensor_of_json assocs
      | _ -> failwith "On top-level list, expects only associations."
    ) l))
  | _ -> failwith "On top-level, expects list or association."


(*

   Generate all the .ml and .mli files

*)

(* Generation helper *)
let modifier stringf regex modifier what =
  stringf (Str.(global_replace (regexp regex) modifier) what)

let mk_ctor ctor =
  let replace i o = Str.(global_replace (regexp i) o) in
  replace "0" "ZERO" ctor |>
  replace "1" "ONE"       |>
  replace "2" "TWO"       |>
  replace "3" "THREE"     |>
  replace "4" "FOUR"      |>
  replace "5" "FIVE"      |>
  replace "6" "SIX"       |>
  replace "7" "SEVEN"     |>
  replace "8" "EIGHT"     |>
  replace "9" "NINE"      |>
  replace "&" "_AND_"
  
  
let type_of_nb = function
  | 1 -> "int ufun"
  | n -> Printf.sprintf "int_tuple%d ufun" n

let function_of_nb nb =
  Printf.sprintf "checked_read read%d" nb

let fp = Format.fprintf
(* * *)
           

let write_opens fmt opens =
  List.iter (fp fmt "@[open %s@]@\n") opens


(*
   Type writers
*)

let write_constructor fmt (constructor, doc) =
  fp fmt "@\n| %s" constructor;
  if doc then fp fmt "@ (** Constructor for %s mode. *)" constructor
  
let write_constructors fmt (constructors, doc) =
  List.iter (fun x -> write_constructor fmt (x, doc)) constructors

let write_type fmt (type_name, ctors, kind, doc) = 
  fp fmt "@[<hov 2>type %s = %a@]"
    type_name write_constructors (ctors, doc);
  if doc then
    fp fmt "@\n(** Type for %s of the sensor %s. *)@\n@\n"
      kind type_name
  else
    fp fmt "@\n@\n"

let write_type_modes fmt (type_modes, ctors, doc) =
  write_type fmt (type_modes, ctors, "modes", doc)

let write_type_commands fmt (type_commands, ctors, doc) =
  if ctors <> [] then
    write_type fmt (type_commands, ctors, "commands", doc)

let write_type_equal fmt (type_name, type_eq) =
  fp fmt "@[<hov 2>type %s = %s@]" type_name type_eq


(*
   module helper
*)

let write_helper_module fmt (name, type_infos, other) =
  fp fmt
    "@\n@[<hov 2>module %s = struct@\n%a%t@]@\nend@\n"
    name write_type_equal type_infos other


(*
   val writer
*)
let write_vals fmt (vals, doc) =
  List.iter (fun (fname, nb) ->
      fp fmt "@\nval %s : %s" fname (type_of_nb nb);
      if doc then
        fp fmt "@\n(** [%s ()] returns the \
                current value of the mode %s *)@\n" fname fname
    ) vals

(*
   to/of_string functions
*)
let write_pattern_matching fmt (left, right) =
  List.iter2 (fp fmt "@\n| %s -> %s") left right

let write_of_string fmt (name, left, right) =
  let left = List.map (fun x -> Printf.sprintf "\"%s\"" x) left in
  fp fmt "@\n@[<hov 2>let %s_of_string = function%a\
          @\n| _ -> assert false@]@\n"
    name write_pattern_matching (left, right)

let write_to_string fmt (name, left, right, default) =
  let right = List.map (fun x -> Printf.sprintf "\"%s\"" x) right in
  fp fmt "@\n@[<hov 2>let string_of_%s = function%a%t@]@\n"
    name write_pattern_matching (left, right)
    (fun fmt -> match default with
         None -> ()
       | Some s -> fp fmt "@\n| _ -> %s" s)


(*
   module type writer
*)

let write_include_abstract_sensor fmt (type_commands, type_modes) =
  fp fmt "@[<hov 2>include Sensor.AbstractSensor@\n";
  fp fmt "with type commands := %s@\n" type_commands;
  fp fmt " and type modes    := %s@]@\n" type_modes

let write_module_type
    fmt (module_type_name, type_modes, type_commands,
         ctors_cmds, informations, doc) =
  let ctors = List.map (fun (_, x, _, _) -> x) informations in
  let vals  = List.map (fun (_, _, x, y) -> (x, y)) informations in
  fp fmt
    "@\n@[<hov 2>module type %s = sig@\n@\n%a%a%a%a@]@\nend@\n@\n"
    module_type_name
    write_type_commands (type_commands, ctors_cmds, doc)
    write_type_modes (type_modes, ctors, doc)
    write_include_abstract_sensor
    ((if ctors_cmds <> [] then type_commands else "unit"), type_modes)
    write_vals (vals, doc)


(* The module implementation writer for ML files. *)
let write_module_ml fmt name driver_name module_commands module_mode
    path_mode type_modes type_commands cmds informations =
  let write_functor fmt functors =
    List.iter (fun (x, y) -> fp fmt "@ (%s : %s)" x y) functors
  in
  let write_module_commands fmt (ns, cs) =
    let err = "failwith \"commands are not available for this sensor.\"" in
    let (type_commands, cs, ns, err) =
      if ns <> [] then (type_commands, cs, ns, None)
      else ("unit", [], [], Some err)
    in
      write_helper_module fmt
        (module_commands, ("commands", type_commands), (fun fmt ->
             write_to_string fmt ("commands", cs, ns, err)))
  in
  let write_module_mode fmt (ns, cs) =
    write_helper_module fmt
      (module_mode, ("modes", type_modes), (fun fmt ->
          write_of_string fmt ("modes", ns, cs);
          write_to_string fmt ("modes", cs, ns, None);
          fp fmt "@[let default_mode = %s@]" (List.hd cs)))
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
    fp fmt "@\n@[<hov 2>include Make_abstract_sensor\
            (%s)@;<0>(%s)@;<0>(DI)@;<0>(%s)@\n"
      (name ^ "Commands") module_mode path_mode
  in
  let write_lets fmt vals =
    List.iter (fun (c, fn, n) ->
        fp fmt "@\n@[let %s = %s@ %s@]" fn (function_of_nb n) c
      ) vals
  in

  let names = List.map (fun (n, _, _, _) -> n) informations in
  let ctors = List.map (fun (_, c, _, _) -> c) informations in
  let lets  = List.map (fun (_, c, fn, n) -> (c, fn, n)) informations in

  let cmds_ctors =
    List.map (fun x -> (mk_ctor (modifier uppercase "-" "_" x))) cmds
  in
  
  fp fmt
    "@\n@[<hov 2>module %s%a = struct@\n%a%a%a%a@\n%t%t%a@]@\nend@\n@\n"
    name
    write_functor [("DI", "DEVICE_INFO"); ("P", "OUTPUT_PORT")]
    write_type_commands (type_commands, cmds_ctors, false)
    write_type_modes (type_modes, ctors, false)
    write_module_commands (cmds, cmds_ctors)
    write_module_mode (names, ctors)
    write_path_maker
    write_includes
    write_lets lets

(* The module implementation writer on MLI file. *)
let write_module_mli fmt name module_name module_type_name =
  fp fmt "@[module %s (DI : Device.DEVICE_INFO) (P: Port.OUTPUT_PORT) : %s@]@\n"
    module_name module_type_name;
  fp fmt "@[(** Implementation of %s. *)@]@\n" name

let write_mli_header fmt name link =
  fp fmt "@[(** Implementation of the sensor %s.@;<1 4>Documentation {{:%s} page} *)@]@\n"
    name link

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
  let type_commands = modifier lowercase "[A-Z]" "_\\0" name ^ "_commands" in
  let module_commands =  module_name ^ "Commands" in
  let type_modes = modifier lowercase "[A-Z]" "_\\0" name ^ "_modes" in
  let module_modes = module_name ^ "Modes" in
  let path_finder = module_name ^ "PathFinder" in
  let modes_informations =
    List.map (fun (mode, name, nb) ->
        let ctor = mk_ctor (modifier uppercase "-" "_" mode) in
        let fname = modifier lowercase " " "_" name in
        mode, (* The str-value : kind-like-this *)
        ctor, (* constructor : KIND_LIKE_THIS *)
        fname, (* fname : kind_like_this *)
        nb
      ) sensor.modes
  in

  let ctors_commands =
    List.map (fun x -> mk_ctor (modifier uppercase "-" "_" x)) sensor.commands
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

  write_mli_header mlifmt (the sensor.name) (the sensor.link);
  
  (* Opens *)
  write_on_both write_opens [ "Device"; "Port"; "Sensor" ];

  (* Module type *)
  let module_type doc =
    (module_type_name, type_modes, type_commands,
     ctors_commands, modes_informations, doc)
  in
  write_module_type mlfmt  (module_type false);
  write_module_type mlifmt (module_type true);

  (* Module implementation *)
  write_module_ml mlfmt module_name (the sensor.driver_name) module_commands
    module_modes path_finder type_modes type_commands sensor.commands
    modes_informations;
  write_module_mli mlifmt pretty_name module_name module_type_name;
  
  write_on_both (fun fmt -> fp fmt "@]@\n%t@.") write_compilation_flag;
  (Buffer.to_bytes mlbuffer, Buffer.to_bytes mlibuffer)

let generate sensors where =
  let write_buffer path name ext buffer =
    let chan = open_out (Filename.concat path (name ^ ext)) in
    output_string chan buffer;
    close_out chan
  in
    
  List.iter (fun x ->
      let (ml, mli) = generate_sensor x where in
      let name = the x.name in

      let path = Filename.concat where x.path in
      if not (Sys.file_exists path) then begin
        Unix.mkdir path 0o766
      end;
      
      write_buffer path name ".ml" ml;
      write_buffer path name ".mli" mli
    ) sensors

let () =
  generate (parse "sensors.json") "../src/sensors/"


(*
Local Variables:
compile-command: "make"
End:
*)
