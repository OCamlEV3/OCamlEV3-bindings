
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

let mk_sensor path = {
  path;
  name = None;
  driver_name = None;
  modes = [];
  link = None;
  commands = [];
}

let the = function
  | None -> failwith "the: None is not expected"
  | Some s -> s

(*

   Parsing the JSON to create the structure.

*)

exception Parse_failure of string

let parse_failure fmt =
  Printf.ksprintf (fun msg -> raise (Parse_failure msg)) fmt

let extract_string key = function
  | `String s -> s
  | _ -> parse_failure "Expected a string for key '%s'" key

let extract_assocs = function
  | `Assoc a ->
    [a]
  | `List l  ->
    List.map (function
        | `Assoc a -> a
        | _ -> parse_failure "extract_assocs: on `List, expects only `Assoc"
      ) l
  | _ ->
    parse_failure "extract_assocs: expects `Assoc or `List of `Assoc"

let sensor_of_association sensor assocs =
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
        let mode = function
          | [("mode", `String mode); ("name", `String name); ("nb", `Int i)] ->
            (mode, name, i)
          | _ -> parse_failure "modes: expects keys 'mode', 'name' and 'nb'"
        in
        aux { sensor with modes = List.map mode (extract_assocs right) } xs

      | "link" ->
        aux { sensor with link = Some (extract_string "link" right) } xs

      | "commands" ->
        let commands = 
          begin match right with
          | `String s -> [s]
          | `List l   -> List.map (extract_string "commands") l
          | _ -> parse_failure "commands: expects string of list of string"
          end
        in
        aux { sensor with commands } xs

      | x ->
        parse_failure "Uknown key '%s'" x
  in
  aux sensor assocs

let sensor_of_json = function
  | [("folder", `String path); ("sensors", sensors)] ->
    List.map (sensor_of_association (mk_sensor path)) (extract_assocs sensors)
  | _ ->
    parse_failure "sensor_of_json: expects keys 'folder' and 'sensors'"

let parse path =
  let json = Safe.from_file path in
  List.(flatten (map sensor_of_json (extract_assocs json)))



(*

   Generate all the .ml and .mli files

*)


type generator_informations = {
  sensor_name : string;           (* The written name in json file *)
  pretty_name : string;           (* Pretty name for comments *)
  driver_name : string;           (* The driver name *)
  link        : string;           (* Link to the official doc *)

  functors    : (string * string) list; (* Functors of the module impl *)
  
  (* ALL MODULES INFO *)
  module_name : string;           (* Main module of the sensor *)
  module_type_name : string;      (* Module type associated to the main module *)
  module_commands : string;       (* Commands module *)
  module_modes    : string;       (* Modes module *)
  module_path_finder : string;    (* Path finder module *)

  (* COMMANDS *)
  type_commands : string; (* The name of the commands type *)
  commands_info : (string * string) list; (* String value, Ctor *)
  
  (* MODES *)
  type_modes : string; (* The name of the modes type *)
  modes_info : (string * string * string * int) list;
  (* String value, Constructor, Function name, Nb of param *)
}

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

module List = struct
  include List
  let split4 l =
    let rec aux (a1, a2, a3, a4) = function
      | [] ->
        List.rev a1, List.rev a2, List.rev a3, List.rev a4
      | (a, b, c, d) :: xs ->
        aux (a :: a1, b :: a2, c :: a3, d :: a4) xs
    in aux ([], [], [], []) l
end

let fp = Format.fprintf
(* * *)
           

(*
   Write all the opens
*)
           
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

let write_type_equal fmt (type_name, type_eq) =
  fp fmt "@\n@[<hov 2>type %s = %s@]" type_name type_eq

let write_type fmt (type_name, ctors, kind, doc) = 
  fp fmt "@\n@[<hov 2>type %s = %a@]"
    type_name write_constructors (ctors, doc);
  if doc then
    fp fmt "@\n(** Type for %s of the sensor %s. *)@\n"
      kind type_name
  else
    fp fmt "@\n"

let write_type_modes fmt (ginfo, doc) =
  write_type fmt
    (ginfo.type_modes,
     List.map (fun (_, x, _, _) -> x) ginfo.modes_info, "modes", doc)

let write_type_commands fmt (ginfo, doc) =
  if ginfo.commands_info <> [] then
    write_type fmt
      (ginfo.type_commands, List.map snd ginfo.commands_info,
       "commands", doc)
  else
    write_type_equal fmt (ginfo.type_commands, "unit")

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
   module helper
*)

let write_helper_module fmt (name, type_infos, other) =
  fp fmt
    "@\n@[<hov 2>module %s = struct%a%t@]@\nend@\n"
    name write_type_equal type_infos other

let write_helper_module_commands fmt ginfo =
  let err =
    if ginfo.commands_info = [] then
      Some "failwith \"commands are not available for this sensor.\""
    else
      None
  in
  let ns, cs = List.split ginfo.commands_info in
  let cmd = "commands" in
  write_helper_module fmt
    (ginfo.module_commands, (cmd, ginfo.type_commands),
     (fun fmt -> write_to_string fmt (cmd, cs, ns, err)))

let write_helper_module_modes fmt ginfo =
  let m = "modes" in
  let (ns, cs, _, _) = List.split4 ginfo.modes_info in
  write_helper_module fmt
    (ginfo.module_modes, (m, ginfo.type_modes),
     (fun fmt ->
        write_of_string fmt (m, ns, cs);
        write_to_string fmt (m, cs, ns, None);
        fp fmt "@\n@[let default_mode = %s@]" (List.hd cs)))
    

(*
   val writer
*)
let write_vals fmt (ginfo, doc) =
  List.iter (fun (_, _, fname, nb) ->
      fp fmt "@\nval %s : %s" fname (type_of_nb nb);
      if doc then
        fp fmt "@\n(** [%s ()] returns the \
                current value of the mode %s *)@\n" fname fname
    ) ginfo.modes_info


(*
   module type writer
*)

let write_include_abstract_sensor fmt ginfo =
  fp fmt "@\n@[<hov 2>include Sensor.AbstractSensor@\n";
  fp fmt "with type commands := %s@\n" ginfo.type_commands;
  fp fmt " and type modes    := %s@]@\n" ginfo.type_modes

let write_module_type fmt ((ginfo, doc) as state) =
  fp fmt
    "@\n@[<hov 2>module type %s = sig%a%a%a%a@]@\nend@\n"
    ginfo.module_type_name
    write_type_commands state
    write_type_modes state
    write_include_abstract_sensor ginfo
    write_vals state

(*
   write functors for module implementation
*)
let write_functors fmt ginfo =
  List.iter (fun (x, y) -> fp fmt "@;<1 2>(%s : %s)" x y) ginfo.functors

(* The module implementation writer for ML files. *)
let write_module_ml fmt ginfo =
  let write_path_maker fmt =
    fp fmt "@\n@[<hov 4>module %s = Path_finder.Make(struct@\n\
            @[let prefix = \"/sys/class/lego-sensor\"@]@\n\
            @[<hov 2>let conditions = [\
            @\n(\"name\", \"%s\");\
            @\n(\"port\", string_of_output_port P.output_port)\
            @]@\n]\
            @]@\n  end)@\n"
      ginfo.module_path_finder ginfo.driver_name;
  in
  let write_includes fmt =
    fp fmt "@\n@[<hov 4>include Make_abstract_sensor\
            (%s)@;<0>(%s)@;<0>(DI)@;<0>(%s)@]@\n"
      ginfo.module_commands ginfo.module_modes ginfo.module_path_finder
  in
  let write_lets fmt ginfo =
    List.iter (fun (_, constructor, fname, nb_params) ->
        fp fmt "@\n@[let %s = %s@ %s@]"
          fname (function_of_nb nb_params) constructor
      ) ginfo.modes_info
  in
  fp fmt
    "@\n@[<hov 2>module %s%a = struct%a%a%a%a%t%t%a@]@\nend@\n@\n"
    ginfo.module_name
    write_functors ginfo
    write_type_commands (ginfo, false)
    write_type_modes (ginfo, false)
    write_helper_module_commands ginfo
    write_helper_module_modes ginfo
    write_path_maker
    write_includes
    write_lets ginfo

(* The module implementation writer on MLI file. *)
let write_module_mli fmt ginfo =
  fp fmt "@\n@[<hov 2>module %s%a@;<1 4>: %s@]"
    ginfo.module_name write_functors ginfo ginfo.module_type_name;
  fp fmt "@\n@[(** Implementation of %s. *)@]@\n" ginfo.pretty_name

let write_mli_header fmt ginfo =
  fp fmt "@[(** Implementation of the sensor %s.@;<1 4>\
          Documentation {{:%s} page} *)@]@\n"
    ginfo.sensor_name ginfo.link

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
  let sensor_name = the sensor.name in
  let pretty_name = modifier capitalize "[A-Z]" " \\0" sensor_name in
  let link        = the sensor.link in
  let driver_name = the sensor.driver_name in
  
  let functors    = [("DI", "DEVICE_INFO"); ("P", "OUTPUT_PORT")] in
  
    
  (* Modules *)
  let module_name        = modifier capitalize "" "" sensor_name in
  let module_type_name   = modifier uppercase "[A-Z]" "_\\0" sensor_name in
  let module_commands    = module_name ^ "Commands" in
  let module_modes       = module_name ^ "Modes" in
  let module_path_finder = module_name ^ "PathFinder" in

  let basic_type = modifier lowercase "[A-Z]" "_\\0" sensor_name in
  (* Commands *)
  let type_commands = basic_type ^ "_commands" in
  let commands_info = List.map (fun x ->
      (x, mk_ctor (modifier uppercase "-" "_" x))
    ) sensor.commands
  in

  (* Modes *)
  let type_modes = basic_type ^ "_modes" in
  let modes_info = List.map (fun (mode, name, nb_params) ->
      let ctor = mk_ctor (modifier uppercase "-" "_" mode) in
      let fname = modifier lowercase " " "_" name in
      (mode, ctor, fname, nb_params)
    ) sensor.modes
  in

  let generator_informations = {
    sensor_name;        pretty_name;     driver_name;
    link;               functors;        module_name;
    module_type_name;   module_commands; module_modes;
    module_path_finder; type_commands;   commands_info;
    type_modes;         modes_info
  } in
  
  
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

  write_mli_header mlifmt generator_informations;
  
  (* Opens *)
  write_on_both write_opens [ "Device"; "Port"; "Sensor" ];

  (* Module type *)
  write_module_type mlfmt  (generator_informations, false);
  write_module_type mlifmt (generator_informations, true);

  (* Module implementation *)
  write_module_ml  mlfmt  generator_informations; 
  write_module_mli mlifmt generator_informations;
  
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
