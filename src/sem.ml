open Ast

module DA = DynArray
module L = List

module B = Buffer
module Pf = Printf

let rec o_cmds o = function
  | [] -> ()
  | c :: cs -> Pf.fprintf o "%a %a" o_cmd c o_cmds cs

and o_cmd o = function
  | C_yo   -> Pf.fprintf o "yo"
  | C_YO   -> Pf.fprintf o "YO"
  | C_Yo_E -> Pf.fprintf o "Yo!"
  | C_Yo_Q -> Pf.fprintf o "Yo?"
  | C_YO_E -> Pf.fprintf o "YO!"
  | C_yo_Q -> Pf.fprintf o "yo?"
  | C_loop cs -> Pf.fprintf o "yo!\n%a\nYO?" o_cmds cs
(*
  | C_yo_E -> Pf.fprintf o "yo!"
  | C_YO_Q -> Pf.fprintf o "YO?"
*)

type state = {
  ptr : int;
  cells : char DA.t; 
}

let rec state_to_string (s: state) : string =
  let buf = B.create ((DA.length s.cells) + 3) in
  B.add_string buf ("{"^(string_of_int s.ptr)^"|");
  DA.iter (fun c -> B.add_string buf (" "^(cell_to_string c))) s.cells;
  B.add_char buf '}';
  B.contents buf

and cell_to_string (c: char) : string =
  let i = int_of_char c in
  Pf.sprintf "0x%X" i

let byte_op (op: int -> int) (c: char) : char =
  let i = int_of_char c in
  char_of_int (op i)

let write (s: state) (c: char) : unit =
  DA.set s.cells s.ptr c

let expand (s: state) : unit =
  try DA.insert s.cells s.ptr (char_of_int 0)
  with DA.Invalid_arg _ ->
    for i = DA.length s.cells to s.ptr do
      DA.insert s.cells i (char_of_int 0)
    done

let read (s: state) : char =
  try DA.get s.cells s.ptr
  with DA.Invalid_arg _ ->
    expand s;
    DA.get s.cells s.ptr

(* step : state -> cmd -> state *)
let rec step (pre: state) (c: cmd) : state =
(*
  Pf.fprintf stderr "%s\n" (state_to_string pre);
  Pf.fprintf stderr "%a\n" o_cmd c;
*)
  match c with
  (* inc data ptr *)
  | C_yo -> { pre with ptr = pre.ptr + 1; }
  (* dec data ptr *)
  | C_YO -> { pre with ptr = pre.ptr - 1; }
  (* inc the byte at the ptr *)
  | C_Yo_E ->
    let c = byte_op ((+) 1) (read pre) in
    write pre c; pre
  (* dec the byte at the ptr *)
  | C_Yo_Q ->
    let c = byte_op ((+) (-1)) (read pre) in
    write pre c; pre
  (* output the byte at the ptr *)
  | C_YO_E ->
    print_char (read pre); pre
  (* accept one byte of input *)
  | C_yo_Q ->
    let c = input_char stdin in
    write pre c; pre
  (* while ( *ptr ) { body } *)
  | C_loop cs ->
    let post = ref pre 
    and cond = ref (read pre)
    in
    while !cond <> (char_of_int 0) do
      post := L.fold_left step !post cs;
      cond := read !post;
    done;
    !post
(*
  (* if the byte at the ptr is zero, instead of advancing the ptr once,
     jump toward the cmd after the matching YO? *)
  | C_yo_E -> pre
  (* if the byte at the ptr is nonzero, instead of advancing the ptr once,
     jump backward the cmd after the matching yo! *)
  | C_YO_Q -> pre
*)

let run (p: prog) : unit =
  let init_st = {
    ptr = 0;
    cells = DA.create ();
  }
  in
  ignore (L.fold_left step init_st p)

