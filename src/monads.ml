
module type MONAD_TYPE =
sig
  type 'a m
end

module type MONAD = sig
  include MONAD_TYPE

  val bind   : 'a m -> ('a -> 'b m) -> 'b m
  val map    : ('a -> 'b) -> 'a m -> 'b m
  val return : 'a -> 'a m

  module INFIX : sig
    val ( >>= ) : 'a m -> ('a -> 'b m) -> 'b m
    val ( =<< ) : ('a -> 'b m) -> 'a m -> 'b m
    val ( >|= ) : 'a m -> ('a -> 'b) -> 'b m
    val ( =|< ) : ('a -> 'b) -> 'a m -> 'b m
  end
end

module SimpleMonadType = struct
  type 'a m = 'a
end

module SimpleMonad : MONAD = struct
  include SimpleMonadType

  let bind x f = f x
  let map f x  = f x
  let return x = x

  module INFIX = struct
    let ( >>= )     = bind
    let ( =<< ) f x = bind x f
    let ( >|= ) x f = map f x
    let ( =|< )     = map
  end
end

module LwtMonadType = struct
  type 'a m = 'a Lwt.t
end

module LwtMonad : MONAD = struct
  include LwtMonadType

  let bind   = Lwt.bind
  let map    = Lwt.map
  let return = Lwt.return

  module INFIX = struct
    let ( >>= ) = Lwt.Infix.( >>= )
    let ( =<< ) = Lwt.Infix.( =<< )
    let ( >|= ) = Lwt.Infix.( >|= )
    let ( =|< ) = Lwt.Infix.( =|< )
  end
end
