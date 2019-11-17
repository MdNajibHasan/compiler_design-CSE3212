%{
    #include<stdio.h>
    #include<math.h>
    int yylex(void);
    void yyerror(char const *);
%}

%define api.value.type {double}
%token NUM
%left '-' '+'
%left '*' '/'
%precedence NEG
%right '^'

%%
input:
     %empty
    | input line
    ;
line:
    '\n'
    | exp '\n'  { printf ("%.10g\n", $1); }
    ;
exp:
    NUM
    | exp '+' exp   {$$ = $1 + $3;    }
    | exp '-' exp   {$$ = $1 - $3;    }
    | exp '*' exp   {$$ = $1 * $3;    }
    | exp '/' exp   {$$ = $1 / $3;    }
    | exp '^' exp   {$$ =  pow($1,$3);    }
    | '-' exp %prec NEG {$$ = -$2;  }
    | '(' exp ')'   {$$ = $2;       }
    ;
%%
int main()
{
	printf("\nDeclaration : ");
	/*yyin = fopen("a.txt","r");*/
	yyparse();
	return 0;
}

void yyerror (char const *s)
{
	fprintf (stderr, "%s\n", s);
}

int yywrap()
{
	return 0;
}
