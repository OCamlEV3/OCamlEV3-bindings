
module type MONAD_TYPE =
sig
  type 'a m
end

module type MONAD =
sig
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

module SimpleMonad : MONAD
module LwtMonad    : MONAD with type 'a m = 'a Lwt.t
