SOURCES := \
	ocamlutil/enum.ml ocamlutil/dynArray.ml \
	src/ast.mli src/parser.mly src/lexer.mll \
	src/sem.ml src/main.ml

RESULT := yo

OCAMLFLAGS := -g
PACKS := sha
LIBS := unix str
ANNOTATE := yes
CC := gcc

all: native-code

-include OCamlMakefile

