%{
	#include <stdio.h>
	#include "lab4.tab.h"
	extern int yylval;
%}

NUM [0-9]+
PLUS "+"
MINUS "-"
MUL "*"
DIV "/"

%%

[ \t]+
[" "]*	
{NUM}	{(sscanf(yytext,"%d",&yylval)) ; return(NUMBER) ;}
{PLUS}	return(PLUS);
{MINUS}	return(MINUS);          
{MUL}	return(ASTERISK);
{DIV}	return(SLASH);
[()]	return(*yytext);
"\n"	return(NEWLINE);	
.	{ printf("\nunknown character"); }
%%

/* user subroutines */

int main()
{
	printf("\nDeclaration : ");
	/*yyin = fopen("a.txt","r");*/
	yyparse();
	return 0;
}

void yyerror (char const *s)
{
	fprintf (stderr, "%s\n", s);
}

int yywrap()
{
	return 0;
}
