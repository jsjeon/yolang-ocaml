module A = Array
module L = List

module Pf = Printf

let usage = "Usage:\n\t" ^ Sys.argv.(0) ^ " [file.yo]\n"

let main () =
  let argn = A.length Sys.argv in
  if argn > 2 then
    failwith usage;
  Printexc.record_backtrace true;
  try
    let ch, f =
      if argn = 1 then stdin, fun () -> ()
      else
        let chan = open_in Sys.argv.(1) in
        chan, fun () -> close_in chan
    in
    let lexbuf = Lexing.from_channel ch in
    let p = Parser.main Lexer.token lexbuf in
    f ();
    Sem.run p

  with End_of_file -> prerr_endline "EOF"
;;

main ();;

