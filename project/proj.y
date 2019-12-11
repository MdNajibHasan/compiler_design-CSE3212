%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "identifier.c"
    int yyparse();
    int yylex();
    int yyerror();
    int ifdone[1000];
    int ifptr=0;
%}
%code requires {
    #ifndef __DT__
    #define __DT__
    struct __DT__ datatype {
        int type;
        char *strval;
        int intval;
        double doubleval;
    };
    #endif
}
%union {
    char text[1009];
    struct datatype val;
}

%token<text>NAME
%token<text>VARACCESS
%token<val>NUM
%token<val>STR
%type<val>expression

%token FUNC CLASS INIT INT DOUBLE STRING CONST VOID VAR
%token ELSEIF ELSE IF
%token FOR WHILE DO
%token CONTINUE RETURN
%token RIGHT_ASSIGN LEFT_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN RIGHT_OP LEFT_OP INC_OP DEC_OP PTR_OP 
%token AND_OP OR_OP LE_OP GE_OP EQ_OP NE_OP

%%
starthere   : functions
functions   : function functions
            | function
            ;
function    : FUNC NAME '(' fparameter ')' PTR_OP TYPE '{' statement '}'
            ;
TYPE        : INT 
            | DOUBLE 
            | STRING 
            | VOID 
            | NAME
            ;
fparameter : 
            | NAME ':' TYPE fsparameter
            ;
fsparameter :
            | ',' NAME ':' TYPE fsparameter
            | ',' NAME ':' TYPE
            ;
statement   :
            | ifgrammer statement
            | declaration statement
            | forgrammer statement
            | asgngrammer statement
            | whilegrammer statement
            | mathexpr statement
            | dowhilegrameer statement
            | returnstmt statement
            ;

mathexpr    : expression ';'
            ;
ifgrammer   : IF '(' expression ')' '{' statement '}' elsifgrmr
            ;
expression  : NUM { $$ = $1;
                     print_datatype($1);
            }
            | STR {
                $$ = $1; print_datatype($1);
            }
            | expression '+' expression { 
                $$ = evaluate($1,$3,"+");
            }
            | expression '-' expression { 
                $$ = evaluate($1,$3,"+");
            }
            | expression '/' expression { 
                $$ = evaluate($1,$3,"+");
            }
            | expression '*' expression { 
                $$ = evaluate($1,$3,"+");
            }
            | expression '<=' expression { 
                $$ = evaluate($1,$3,"+");
            }
            | expression '>=' expression { 
                $$ = evaluate($1,$3,"+");
            }
            | expression '<' expression { 
                $$ = evaluate($1,$3,"+");
            }
            | expression '>' expression { 
                $$ = evaluate($1,$3,"+");
            }
            | expression '==' expression { 
                $$ = evaluate($1,$3,"+");
            }
            | expression '!=' expression { 
                $$ = evaluate($1,$3,"+");
            }
            | '(' expression ')' { 
                $$ = $2;
            }
            ;

returnstmt  : RETURN mathexpr
            | RETURN ';'

declaration :VAR varriables ';'
            ;
varriables  : varriable ',' varriables
            | varriable
            ;
varriable   : NAME ':' TYPE
            | NAME '=' expression
            | NAME ':' arraydim '*' '(' expression ')'
            | NAME ':' arraydim
            ;
arraydim    : '[' arrayx ']'
            ;
arrayx      : TYPE
            | '[' arrayx ']'
            ;
elsifgrmr   :
            | ELSEIF '(' expression ')' '{' statement '}' elsifgrmr
            | ELSE '{' statement '}'
            ;
asgngrammer : ASGNVAR ',' asgngrammer
            | ASGNVAR ';'
            ;

forgrammer  : FOR '(' forassign ';' expression ';' forassign ')' '{' statement '}'
            ;

forassign   : ASGNVAR ',' forassign
            | ASGNVAR
ASGNVAR     : VARACCESS '=' expression
            ;
        
whilegrammer    : WHILE '(' expression ')' '{' statement '}'
                ;
dowhilegrameer  : DO '{' statement '}' WHILE '(' expression ')' ';'

%%
extern char yytext[];
extern int column;
int yyerror(char *s){
    fflush(stdout);
	printf("\n%*s\n%*s\n", column, "^", column, s);
}