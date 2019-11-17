%{
	#include <stdio.h>
	#include "prac.tab.h"
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
