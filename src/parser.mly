%{
open Ast
%}

%token EOF

%token T_yo
%token T_YO
%token T_Yo_E
%token T_Yo_Q
%token T_YO_E
%token T_yo_Q
%token T_yo_E
%token T_YO_Q

%type <Ast.prog> main
%type <Ast.cmd list> cmds
%type <Ast.cmd> cmd

%start main
%%
main:
  | cmds EOF { $1 }
;
cmds:
  | { [] }
  | cmd cmds { $1 :: $2 }
;
cmd:
  | T_yo   { C_yo   }
  | T_YO   { C_YO   }
  | T_Yo_E { C_Yo_E }
  | T_Yo_Q { C_Yo_Q }
  | T_YO_E { C_YO_E }
  | T_yo_Q { C_yo_Q }
  | T_yo_E cmds T_YO_Q { C_loop $2 }
/*
  | T_yo_E { C_yo_E }
  | T_YO_Q { C_YO_Q }
*/

