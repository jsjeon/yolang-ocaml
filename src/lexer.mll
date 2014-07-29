{
open Parser
exception Eof

module Pf = Printf
}

rule token = parse
  | "/*" { comments 0 lexbuf }
  | [' ' '\t' '\n' '\r'] { token lexbuf }

  | "yo"  { T_yo   }
  | "YO"  { T_YO   }
  | "Yo!" { T_Yo_E }
  | "Yo?" { T_Yo_Q }
  | "YO!" { T_YO_E }
  | "yo?" { T_yo_Q }
  | "yo!" { T_yo_E }
  | "YO?" { T_YO_Q }

  | eof { EOF }

  | _ as lxm { Pf.printf "Illegal character %c\n" lxm; failwith "Bad input" }

and comments level = parse
  | "*/" { if level = 0 then token lexbuf else comments (level-1) lexbuf }
  | "/*" { comments (level+1) lexbuf }
  | _ { comments level lexbuf }
  | eof { failwith "comments not closed" }

