%{
	#include <stdio.h>
    #include<stdlib.h>
    #include<string.h>
	#include "lab5.tab.h"
	extern int yylval;
%}
num [0-9]+
%%
"int "[a-z]" = "[0-9]+";" {
    printf("INT delclared\n");
    printf("varriable name: %c\n",yytext[4]);
    printf("value : ");
    for(int i=8;i<strlen(yytext)-1;i++){
        printf("%c",yytext[i]);
    }
    printf("\n");
}
"float "[a-z]" = "[0-9]*.[0-9]+";" {
    printf("Float delclared\n");
    printf("varriable name: %c\n",yytext[6]);
    printf("value : ");
    for(int i=10;i<strlen(yytext)-1;i++){
        printf("%c",yytext[i]);
    }
    printf("\n");
}
"char "[a-z]" = "[a-z]+";" {
    printf("Char delclared\n");
    printf("varriable name: %c\n",yytext[5]);
    printf("value : ");
    for(int i=9;i<strlen(yytext)-1;i++){
        printf("%c",yytext[i]);
    }
    printf("\n");
}
"int "[a-z]" = ".*";" {
        printf("Error in int delaration\n");
}
"float "[a-z]" = ".*";" {
    printf("Error in float delaration\n");
}
"char "[a-z]" = ".*";" {
    printf("Error in char delaration\n");
}

[0-9]+ {
    yylval = atoi(yytext);
    return NUM;
}
[a-z] {
    yylval = *yytext -'a';
    return VAR;
}
[-+/*<>=,();] {
    yylval = yytext[0];
    return *yytext;
}
"if" {return IF;}
"else" {return ELSE;}
[ \t\n]* ;

%%
