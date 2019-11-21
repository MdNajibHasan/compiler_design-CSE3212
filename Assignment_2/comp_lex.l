char [a-zA-Z]
digit [0-9]
special [$_@]
space " "
newline "\n"
Datatype "int"|"double"|"char"|"void"
Operator "="|"+"|"-"|"/"|"*"|"&"|"|"|"%"
Relational_Operator "<"|">"|"<="|">="|"&&"|"||"|"=="|"!="
Identifier ({char}|{digit}|{special})+

%{
    #include "comp_bison.tab.h"
    #include <string.h>
    int yyparse();
    int yylex();
    int yyerror();
    int st=0;
    FILE *flexo;
%}

%%
{newline} {st++;yylval.lineval=st;}
{space} {}
"#".*"#" {}
";" {return SM;}
"," {return CM;}
{digit}+ {
    fprintf(flexo,"lex 1 :: %s\n",yytext);
    yylval.val = atoi(yytext);
    return NUM;
}

"prg_main" { fprintf(flexo,"lex 2:: %s\n",yytext);return MAIN;}
"prg_println" { fprintf(flexo,"lex 3:: %s\n",yytext);return PRINTLN;}
"prg_print" { fprintf(flexo,"lex 4:: %s\n",yytext);return PRINT;}
"prg_"({char}|{digit}|{special})+ {fprintf(flexo,"lex 5:: %s\n",yytext);return FUNCTION;}
"var_"({char}|{digit}|{special})+ {fprintf(flexo,"lex 6:: %s\n",yytext);strcpy(yylval.text,yytext);return ID;}

"int" {fprintf(flexo,"lex 7:: %s\n",yytext);return INT;}
"double" {fprintf(flexo,"lex 8:: %s\n",yytext);return DOUBLE;}
"char" {fprintf(flexo,"lex 9:: %s\n",yytext);return CHAR;}

"(" {fprintf(flexo,"lex 10:: %s\n",yytext);return PB;}
")" {fprintf(flexo,"lex 11:: %s\n",yytext);return PE;}

"{" {fprintf(flexo,"lex 12:: %s\n",yytext);return BB;}
"}" {fprintf(flexo,"lex 13:: %s\n",yytext);return BE;}

"<=" {fprintf(flexo,"lex 14:: %s\n",yytext);return LE;}
">=" {fprintf(flexo,"lex 15:: %s\n",yytext);return GE;}
"==" {fprintf(flexo,"lex 16:: %s\n",yytext);return EQU;}
"!=" {fprintf(flexo,"lex 17:: %s\n",yytext);return NEQU;}
"=" {fprintf(flexo,"lex 18:: %s\n",yytext);return ASGN;}
"+" {fprintf(flexo,"lex 19:: %s\n",yytext);return PLUS;}
"-" {fprintf(flexo,"lex 20:: %s\n",yytext);return MINUS;}
"*" {fprintf(flexo,"lex 21:: %s\n",yytext);return MULT;}
"/" {fprintf(flexo,"lex 22:: %s\n",yytext);return DIV;}
"<" {fprintf(flexo,"lex 23:: %s\n",yytext);return LT;}
">" {fprintf(flexo,"lex 24:: %s\n",yytext);return GT;}
"else_if" { fprintf(flexo,"lex 25:: %s\n",yytext);return ELSEIF;}
"if" { fprintf(flexo,"lex 27:: %s\n",yytext);return IF;}
"else" {fprintf(flexo,"lex 28:: %s\n",yytext);return ELSE;}
. {fprintf(flexo,"lex 29:: %s\n",yytext);}
"\""(.)*"\"" { fprintf(flexo,"lex 30:: %s\n",yytext);strcpy(yylval.text,yytext);return STR;}

%%

int yywrap()
{
	return 1;
}

int main(){
	st=0;
    yyin = freopen("sample.txt","r",stdin);
	//freopen("output.txt","w",stdout);
	flexo = fopen("lex_out.txt","w");
    yyparse();
    fclose(flexo);
}