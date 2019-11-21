%{
	#include <stdio.h>
	#include "prac.tab.h"
%}

%%
[ \t\n] ;
[0-9]+\.[0-9]+ { printf("OK float\n");yylval.fval = atof(yytext);return FLOAT; }
[0-9]+ { printf("OK int\n");yylval.ival = atoi(yytext); return INT; }
[a-zA-Z0-9]+ {
	printf("OK STRING\n");
	yylval.sval = strdup(yytext);
	return STRING;
}
%%
int yywrap()
{
    return 1;
}
