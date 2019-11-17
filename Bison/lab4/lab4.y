%{#define YYSTYPE int
#include<malloc.h>
#include<stdio.h>
#include<math.h>
%}
%token NEWLINE NUMBER PLUS MINUS SLASH ASTERISK LPAREN RPAREN
%left PLUS MINUS
%left ASTERISK SLASH
%right EXPONEN
%start input
%%
input:  /* empty string */
        | input line
        ;
line:   NEWLINE
        | exp NEWLINE { printf("\t%d\n",$1); }
        ;
exp:    NUMBER { $$ = $1;}
        | exp PLUS exp { $$ = $1 + $3 ;}
        | exp MINUS exp { $$ = $1 - $3 ;}
        | exp ASTERISK exp { $$ = $1 * $3 ;}
        | exp SLASH exp { $$ = $1 / $3 ;}
        | LPAREN SLASH RPAREN { $$ = $2 ;}
        ;
%%