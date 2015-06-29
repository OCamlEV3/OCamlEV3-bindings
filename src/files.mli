
(**	  Easy way to write and read files

      This module handle files to get an easier way to write & read into them.
      It was necessary to maintain descriptor with their channels, to flush and
      seek at any time without always writing this.
 *)

(** The file type. *)
type t

(** Raise when trying to make an action on closed channel. *)
exception Invalid_channel of string

(** Raised when trying to read/write a wrong file. *)
exception Invalid_file of string

(** Open a file in both read and write mode. *)
val fopen_both : string -> t

(** Open a file in read mode. *)
val fopen_in   : string -> t

(** Open a file in write mode. *)
val fopen_out  : string -> t

(** Write in file and flush right after *)
val fwrite : t -> string -> unit

(** Read in file and lseek right after *)
val fread  : t -> string

(** Close a file. *)
val fclose : t -> unit

(** Open the file, write in it, and close the file. *)
val kfwrite : string -> string -> unit

(** Open the file, read the line, and close the file. *)
val kfread  : string -> string
