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
    #include "proj.tab.h"
    #include <string.h>
    int yyparse();
    int yylex();  
    int yyerror();
    FILE *flexo;
    void count();
    int multicomm=0;
%}
%%
"/*"			{ comment(); }
[ \t\v\n\f]		{ count(); }
"func" { 
    count();
    return FUNC;
}
"var" { 
    count();
    return VAR;
}
"class" {
    count();
    return CLASS;
}
"init" {
    count();
    return INIT;
}
"Int" {
    count();
    return INT;
}
"Double" {
    count();
    return DOUBLE;
}
"String" {
    count();
    return STRING;
}
"else if" {
    count();
    return ELSEIF;
}
"else" {
    count();
    return ELSE;
}
"if" {
    count();
    return IF;
}
"for" {
    count();
    return FOR;
}
"while" {
    count();
    return WHILE;
}
"const" {
    count();
    return CONST;
}
"continue" {
    count();
    return CONTINUE;
}
"return" {
    count();
    return RETURN;
}
"Void" {
    count();
    return VOID;
}
"Class" {
    count();
    return CLASS;
}
{digit}*"."{digit}+ {
    count();
    yylval.val.doubleval = atof(yytext);
    yylval.val.type = 3;
    return NUM;
}
{digit}+ {
    count();
    yylval.val.intval = atoi(yytext);
    yylval.val.type = 2;
    return NUM;
}
"$"{Identifier} {
    count();
    strcpy(yylval.text,yytext);
    return VARACCESS;
}
{Identifier} {
    count();
    strcpy(yylval.text,yytext);
    return NAME;
}
">>="			{ count(); return(RIGHT_ASSIGN); }
"<<="			{ count(); return(LEFT_ASSIGN); }
"+="			{ count(); return(ADD_ASSIGN); }
"-="			{ count(); return(SUB_ASSIGN); }
"*="			{ count(); return(MUL_ASSIGN); }
"/="			{ count(); return(DIV_ASSIGN); }
"%="			{ count(); return(MOD_ASSIGN); }
"&="			{ count(); return(AND_ASSIGN); }
"^="			{ count(); return(XOR_ASSIGN); }
"|="			{ count(); return(OR_ASSIGN); }
">>"			{ count(); return(RIGHT_OP); }
"<<"			{ count(); return(LEFT_OP); }
"++"			{ count(); return(INC_OP); }
"--"			{ count(); return(DEC_OP); }
"->"			{ count(); return(PTR_OP); }
"&&"			{ count(); return(AND_OP); }
"||"			{ count(); return(OR_OP); }
"<="			{ count(); return(LE_OP); }
">="			{ count(); return(GE_OP); }
"=="			{ count(); return(EQ_OP); }
"!="			{ count(); return(NE_OP); }

";"			{ count(); return(';'); }
("{"|"<%")		{ count(); return('{'); }
("}"|"%>")		{ count(); return('}'); }
","			{ count(); return(','); }
":"			{ count(); return(':'); }
"="			{ count(); return('='); }
"("			{ count(); return('('); }
")"			{ count(); return(')'); }
("["|"<:")		{ count(); return('['); }
("]"|":>")		{ count(); return(']'); }
"."			{ count(); return('.'); }
"&"			{ count(); return('&'); }
"!"			{ count(); return('!'); }
"~"			{ count(); return('~'); }
"-"			{ count(); return('-'); }
"+"			{ count(); return('+'); }
"*"			{ count(); return('*'); }
"/"			{ count(); return('/'); }
"%"			{ count(); return('%'); }
"<"			{ count(); return('<'); }
">"			{ count(); return('>'); }
"^"			{ count(); return('^'); }
"|"			{ count(); return('|'); }
"?"			{ count(); return('?'); }
"\""(.)*"\"" {
    count();
    yylval.val.type = 4;
    yylval.val.strval = calloc(strlen(yytext),sizeof(char));
    strcpy(yylval.val.strval,yytext+1);
    yylval.val.strval[strlen(yylval.val.strval)-1]=0;
    return STR;
}
%%
int yywrap () {
	return 1;
}
void comment() {
	char c, c1;
loop:
	while ((c = input()) != '*' && c != 0)
		putchar(c);

	if ((c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}

	if (c != 0)
		putchar(c1);
}
int column = 0;
void count () {
    int i;
    for(int i=0;yytext[i]!='\0';i++)
    {
        if(yytext[i]=='\n')
            column=0;
        else if(yytext[i]=='\t')
            column+=(8-(column%8));
        else column++;
    }
    //ECHO;
}
int main () {
    freopen("input.txt","r",stdin);
	flexo = fopen("lex_out.txt","w");
    yyparse();
    fclose(flexo);
}