
(**	Sounds functionalities *)

(**	[speak ~speed:s ~volume:v text] exec the espeak command to say
    the given [text] with the speed [s] and the volume [v]. The default
    speed is 130. The default volume is 150. *)
val speak : ?speed:int -> ?volume:int -> string -> int
