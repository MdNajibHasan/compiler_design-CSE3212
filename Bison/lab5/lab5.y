%{
    #include<stdio.h>
    #include<stdlib.h>
    int sym[26];
    int type;
%}
%token NUM VAR IF ELSE
%nonassoc IFX
%nonassoc ELSE
%left '<' '>'
%left '+' '-'
%left '*' '/'

%%
program : /* null */
        |program statement
        ;
statement:';'
        |expression ';' {printf("value of expression: %d\n",$1);}
        |VAR '=' expression ';' {   sym[$1]=$3;
                                    printf("value of the variable :%d\t\n",$3);
                                }
        |IF '(' expression ')' expression ';' %prec IFX {
                                                         if($3){
                                                            printf("\nvalue of expression in IF: %d\n",$5);
                                                        }
                                                        else {
                                                            printf("condition value zero in IF BLOCK\n");
                                                        }
                                                    }
        |IF '(' expression ')' expression ';' ELSE expression ';' {
                                                        if($3) {
                                                            printf("value of expression in IF : %d\n",$5);
                                                        }
                                                        else {
                                                            printf("value of expression in ELSE : %d\n",$8);
                                                        }
                                                    }
                                

expression:NUM                          { $$=$1;}
            |VAR                        { $$ = sym[$1];}
            |expression '+' expression  { $$ = $1 + $3; }
            |expression '-' expression  { $$ = $1 - $3; }
            |expression '*' expression  { $$ = $1 * $3; }
            |expression '<' expression  { $$ = $1 < $3; }
            |expression '>' expression  { $$ = $1 > $3; }
            |'(' expression ')'         { $$ = $2;}
            |expression '/' expression  { if($3!=0){
                                              $$ = $1 / $3;
                                            }
                                            else {
                                                $$ = 0;
                                                printf("\nDivide by zero occured\n");
                                                exit(-1);
                                            } 
                                        }
%%

int yywrap() {
    return 1;
}
void yyerror(char *s){
    printf("%s\n",s);
}
int main() {
    yyparse();
}
