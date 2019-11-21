%{
    #include<stdio.h>
    #include<math.h>
    extern int yylex();
    extern int yyparse();
    extern FILE *yyin;
    void yyerror(const char *s);
%}

%union {
    int ival;
    float fval;
    char *sval;
}
%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING

%%
snazzle: INT snazzle    {
        printf("int b: %d\n",$1);
    }
    | FLOAT snazzle {
        printf("float b: %g\n",$1);
    }
    | STRING snazzle    {
        printf("string b: %s\n",$1);free($1);
    }
    | INT   {
        printf("int b: %d\n",$1);
    }
    | FLOAT {
        printf("float b: %g\n",$1);
    }
    |STRING {
        printf("string b: %s\n",$1);free($1);
    }
    ;
%%

int main() {
    FILE *myfile = fopen("a.txt","r");
    yyin = myfile;
    yyparse();
}
void yyerror(const char *s) {
  printf("EEK, parse error!  Message: %s\n",s);
  // might as well halt now:
  exit(-1);
}
