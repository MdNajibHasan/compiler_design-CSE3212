%{
    #include<stdio.h>
    #include<math.h>
    #include<stdlib.h>
    int yyparse();
    int yylex();
    void yyerror();
    int ptr;
    int ifdone,elsifdone,whiledone,firstwhile;
%}

%token IF ELSEIF ELSE LT NUM PB PE BB BE GT PLUS MINUS WHILE
%%
statement :/* empty */ 
          |statement ifgrammer
          |statement whilegrammer
          ;
ifgrammer : IF PB expression PE BB statement BE {
          if($3>0){
            printf("IF executed");
            ifdone=1;
          }
      } elsif
      ;
elsif : /* empty */
      | ELSEIF PB expression PE BB statement BE {
          if(ifdone==0 && $3>0 && elsifdone==0)
          {
            printf("ELSEIF executed");
            elsifdone=1;
          }
      } elsif
      | ELSE BB statement BE
      {
        if(ifdone==0 && elsifdone==0)
        {
          printf("ELSE executed");
        }  
      }
      ;
expression : NUM {$$ = $1;}
            | expression LT expression { $$ = $1<$3;}
            | expression GT expression { $$ = $1>$3;}
            | expression PLUS expression { $$ = $1+$3;}
            | expression MINUS expression { $$ = $1-$3;}
            | PB expression PE { $$= $2;}
            ;

whilegrammer : WHILE PB expression PE BB statement BE {
  if($3>0)
    printf("while executed\n");
}
%%

void yyerror(const char *s) {
  printf("EEK, parse error!  Message: %s\n",s);
  // might as well halt now:
  exit(-1);
}
