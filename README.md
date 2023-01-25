# MiniPy-Compiler

A very basic compiler for python developed using lex and yacc.
All the phases of compiler design have been covered and this compiler can parse basic statements, selection and looping constructs.

# Prerequisites

Install flex and bison using the following command which can help interpret .l and .y files.

`sudo apt-get update`
`sudo apt-get install flex`
`sudo apt-get install bison`

# Running the code

`flex lexical.l`
`bison syntaxique.y`
`gcc lex.yy.c syntaxique.tab.c -o minipy -lfl -ly`

`minipy<exemple.txt`

This command will print all the outputs right from lexer parsing to assembly code generated for the file passed through filepath.
