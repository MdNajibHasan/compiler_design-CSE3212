%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include "IF.tab.h"
	extern int yylval;
%}

%%
[\t]
[\n]
[' ']
[0-9]+	{ yylval = atoi(yytext);
	return NUM;
	}

	
[a-z]	{ yylval = *yytext - 'a';
	return VAR;
	}

"if"	{ return IF; }

"else"	{ return ELSE; }

[-*+/><();=,]	{ yylval = yytext[0];
		return *yytext; 
		}

[\t\n]* ;

.	{ printf("unexpected error"); }

%%

int yywrap()
{
	return 1;
}