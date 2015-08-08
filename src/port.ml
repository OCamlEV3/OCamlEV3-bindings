
type input_port  = Input1 | Input2 | Input3 | Input4
                   
type output_port = OutputA | OutputB | OutputC | OutputD

module type INPUT_PORT = sig
  val input_port : input_port
end

module type OUTPUT_PORT = sig
  val output_port : output_port
end

let string_of_input_port = function
   | Input1 -> "in1"
   | Input2 -> "in2"
   | Input3 -> "in3"
   | Input4 -> "in4"

let string_of_output_port = function
  | OutputA -> "outA"
  | OutputB -> "outB"
  | OutputC -> "outC"
  | OutputD -> "outD"
