
type file = Unix.file_descr * in_channel option * out_channel option
type t = file

exception Invalid_channel of string
exception Invalid_file    of string

let get_in_channel d =
  let in_channel = Unix.in_channel_of_descr d in
  set_binary_mode_in in_channel false;
  in_channel

let get_out_channel d =
  let out_channel = Unix.out_channel_of_descr d in
  set_binary_mode_out out_channel false;
  out_channel

let open_ path tag =
  try Unix.(openfile path tag 0o640)
  with _ -> raise (Invalid_file path)

let fopen_both path =
  let descriptor = open_ path [Unix.O_RDWR] in
  (descriptor,
   Some (get_in_channel  descriptor),
   Some (get_out_channel descriptor))

let fopen_in path =
  let descriptor = open_ path [Unix.O_RDONLY] in
  (descriptor, Some (get_in_channel descriptor), None)

let fopen_out path =
  let descriptor = open_ path [Unix.O_WRONLY] in
  (descriptor, None, Some (get_out_channel descriptor))

let rewind descriptor =
  Unix.(lseek descriptor 0 SEEK_SET)

let fwrite (descriptor, _, channel) msg =
  match channel with
  | None ->
    raise (Invalid_channel "fwrite")
  | Some channel ->
    output_string channel msg;
    flush channel;
    ignore @@ rewind descriptor

let fread (descriptor, channel, _) =
  match channel with
  | None ->
    raise (Invalid_channel "fread")
  | Some channel ->
    let line = input_line channel in
    ignore @@ rewind descriptor;
    line

let fclose (descript, in_, out) =
  Unix.close descript;
  let close f = function
    | None   -> ()
    | Some x -> f x
  in
  close close_in in_;
  close close_out out

let kfwrite path message = match Sys.file_exists path with
  | false -> raise (Invalid_file path)
  | true  -> Printf.kfprintf close_out (open_out path) "%s" message

let kfread path = match Sys.file_exists path with
  | false -> raise (Invalid_file path)
  | true  ->
    let channel = open_in path in
    let input   = input_line channel in
    close_in channel; input
