
type usage =
  | ReleaseAfterUse
  | NeverRelease

type mode =
  | Read
  | Write
  | Both

exception Invalid_file of string

let file_table = Hashtbl.create 13

let add usage key value =
  match usage with
  | ReleaseAfterUse -> ()
  | NeverRelease    -> Hashtbl.add file_table key value

let exists     = Hashtbl.mem file_table
let find       = Hashtbl.find file_table
let remove     = Hashtbl.remove file_table

let unix_flag_of_flag = function
  | Read  -> Unix.O_RDONLY
  | Write -> Unix.O_WRONLY
  | Both  -> Unix.O_RDWR

let store_and_return usage mode filename =
  match Sys.file_exists filename with
  | true ->
    begin match Filename.is_relative filename with
    | true ->
      raise (Invalid_file (Printf.sprintf "`%s' have to be absolute" filename))
    | false ->
      let flag = unix_flag_of_flag mode in
      let fd = Unix.openfile filename [flag] 0o640 in
      add usage filename (fd, usage);
      (fd, usage)
    end
  | false ->
    raise (Invalid_file (Printf.sprintf "`%s' doesn't exists." filename))


let store_filename ?(usage = ReleaseAfterUse) ?(mode = Both) filename =
  ignore (store_and_return usage mode filename)

let find_or_create filename mode usage =
  match exists filename with
  | true  -> find filename
  | false -> store_and_return usage mode filename

let check_file_usage filename fd usage =
  match usage with
  | ReleaseAfterUse ->
    Unix.close fd;
    remove filename
  | NeverRelease ->
    ()

let write ?(usage = ReleaseAfterUse) filename message =
  let fd, usage = find_or_create filename Write usage in
  ignore (Unix.(lseek fd 0 SEEK_SET));
  ignore (Unix.single_write_substring fd message 0 (String.length message));
  check_file_usage filename fd usage

let read ?(usage = ReleaseAfterUse) filename =
  let fd, usage = find_or_create filename Read usage in
  ignore (Unix.(lseek fd 0 SEEK_SET));
  let message =
    let buffer = Bytes.create 64 in
    ignore (Unix.read fd buffer 0 64);
    Bytes.to_string buffer
  in
  check_file_usage filename fd usage;
  message
