%{
	#include <stdio.h>
	int sym[26];
	int t=0; 
%}

%token NUM FLO CHAR INTEGER FLOAT CHARACTER VAR IF ELSE
%nonassoc IFX
%left '<' '>'
%left '+' '-'
%left '*' '/'


%%

program:
	| program statement
	;

statement: ';'
	| exp ';'	{ printf("Value of expression: %d\n",$1);}
	| VAR '=' exp ';'	{ sym[$1] = $3;
				printf("Value of variable: %d\n",$3);
				}
	| ifs

ifs: IF '(' exp ')' statement	{ if($3) { printf("Value of expression in IF: %d\n",$3);}
						else { printf(" Value of IF condition is zero");}
						} 
	| IF '(' exp ')' statement ELSE statement	{ if($3) { printf("Value of expression in IF: %d\n",$3);}
						else { printf(" Value of expression in ELSE: %d\n",$7);}
						} 
	;

exp: NUM	{
		$$ = $1; 
		//printf("Value of num: %d\n",$1);
		 }
	| VAR	{ $$ = sym[$1];
		//printf("Value of variable: %d\n",$1);
		}
	| exp '+' exp	{ $$ = $1 + $3; 
			//printf("Value of operation: %d\n",$$);
			}
	| exp '-' exp	{ $$ = $1 - $3;
			//printf("Value of operation: %d\n",$$);
			}
	| exp '*' exp	{ $$ = $1 * $3;
			//printf("Value of operation: %d\n",$$);
			}
	| exp '/' exp	{ if($3) { $$ = $1 / $3; 
			//printf("Value of operation: %d\n",$$); 
			}
			else { $$ = 0;
			//printf("Cannot divide by zero\n");
			}
			}
	| exp '<' exp	{ $$ = $1 < $3;
			//printf("Value of operation: %d\n",$$);
			}
	| exp '>' exp	{ $$ = $1 > $3;
			//printf("Value of operation: %d\n",$$);
			}
	| '(' exp ')'	{ $$ = $2;
			//printf("Value of operation: %d\n",$$);
			}
	;

%%


int yyerror(char *s)
{
	printf("%s \n",s);
	return 0;
}


int main()
{
	yyparse();
}