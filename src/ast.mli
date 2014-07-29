type prog = cmd list

and cmd =
  | C_yo
  | C_YO
  | C_Yo_E
  | C_Yo_Q
  | C_YO_E
  | C_yo_Q
  | C_loop of cmd list
(*
  | C_yo_E
  | C_YO_Q
*)

