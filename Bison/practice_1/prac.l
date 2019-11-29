space " "
newline "\n"
digit [0-9]
%{
	#include <stdio.h>
	#include "prac.tab.h"
	int yyparse();
    int yylex();
	void yyerror();
%}

%%
{space} {}
{newline} {}
"else if" {
	printf("ELSE IF");
	return ELSEIF;
}
"if" {
	printf("IF");
	return IF;
}
"else" {
	return ELSE;
}
{digit}+ {
	yylval=atoi(yytext);
	printf("%s\n",yytext);
	return NUM;
}
"<" {
	return LT;
}
">" {
	return GT;
}
"+" {
	return PLUS;
}
"-" {
	return MINUS;
}
"(" {
	printf("PB\n");
	return PB;
}
")" {
	printf("PE\n");
	return PE;
}
"{" {
	return BB;
}
"}" {
	return BE;
}
"while" {
	return WHILE;
}
%%
int yywrap()
{
	return 1;
}
int main(){
    freopen("input.txt","r",stdin);
	yyparse();
}
