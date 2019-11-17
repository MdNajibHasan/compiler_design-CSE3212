%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include "IF.tab.h"
	extern int yylval;
%}

%%

[0-9]+	{ yylval = atoi(yytext);
	return NUM;
	}

[0-9]+[.][0-9]+	{ yylval = atof(yytext);
		return FLO;
		}
 
['][a-z0-9]['] { yylval = 3;
		return CHAR;
	
[a-z]	{ yylval = *yytext - 'a';
	return VAR;
	}

"if"	{ return IF; }

"else"	{ return ELSE; }

"int"	{ yylval = 1;
	return INTEGER;
	}

"float"	{ yylval = 2;
		return FLOAT;
		}
 
"char"	{ yylval = 3;
		return CHARACTER;
		}
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