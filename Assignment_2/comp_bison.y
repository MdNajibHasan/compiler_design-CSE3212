%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include "comp_utility.c"
    int yyparse();
    int yylex();
    int yyerror();
    struct ll_identifier *root=NULL,*last=NULL;
%}

%union {
    char text[1000];
    int val;
    int lineval;
}

%token <text> ID
%token <val> NUM
%token <text> STR

%type <val> expression

%left LT GT LE GE 
%left PLUS MINUS
%left MULT DIV

%token INT DOUBLE CHAR VOID MAIN PB PE BB BE VARD VARC SM CM ASGN PRINT PRINTLN MINUS MULT DIV LT GT LE GE IF ELSE ELSEIF COL FUNCTION EQU NEQU 
%nonassoc IFX
%nonassoc ELSE
%left SH

%%
starhere    : function program function { 
                printf("\n Compilation Successful\n");
            }
            ;

program     : INT MAIN PB PE BB statement BE
            ;

statement   : /* empty */
            | statement declaration
            | statement print
            | statement ifelse
            | statement assign
            | statement expression
            ;


declaration : type variables SM {
                //printf("came hear declaration\n");
            }
            ;
type        : INT | DOUBLE | CHAR {
                printf("got type\n");
            }
            ;
variables   : variable CM variables {
                printf("variable , variables\n");
            }
            | variable {
                printf("variable\n");
            }
            ;
variable    :ID
                {
                    printf("ok2 %s\n",$1);
                    int res = addNewVal(&root,&last,$1,"");
                    if(!res)
                    {
                        printf("Compilation Error ::  Varribale %s is already declared\n",$1);
                        exit(-1);
                    }
                }
            |ID ASGN expression 
                {
                    printf("ok1 %s %d\n",$1,$3);
                    int n = log10($3) + 1;
                    char *numberArray = calloc(n, sizeof(char));
                    sprintf(numberArray,"%ld",$3);
                    int res = addNewVal(&root,&last,$1,numberArray);
                    if(!res) 
                    {
                        printf("Compilation Error ::  Varribale %s is already declared\n",$1);
                        exit(-1);
                    }
                } 
            ;

assign : ID ASGN expression SM
            {
                printf("Came here\n");
                struct ll_identifier* decl = isDeclared(&root,$1);
                if(decl==NULL)
                {
                    printf("Compilation Error ::  Varribale %s is not declared\n",$1);
                    exit(-1);
                }
                else 
                {
                    int n = log10($3) + 1;
                    char *numberArray = calloc(n, sizeof(char));
                    sprintf(numberArray,"%ld",$3);
                    setVal(&root,&last,$1,numberArray);
                }
            }
        ;
print   :PRINT PB expression PE SM
            {
                printf("Print %s\n",$3);
            }
            |PRINT PB ID PE SM
            {
                struct ll_identifier* decl = isDeclared(&root,$3);
                if(decl==NULL)
                {
                    printf("Compilation Error ::  Varribale %s is not declared\n",$3);
                    exit(-1);
                }
                else
                {
                    printf("Print %s\n",$3);
                }
            }
        | PRINTLN PB PE SM
            {
                printf("\n");
            }
        ;

expression  : NUM {$$=$1; printf("came here num %d\n",$1);}
            | ID 
                {
                    printf("Came expression\n");
                    printf("%s\n",$1);
                    
                    struct ll_identifier* res = isDeclared(&root,$1);
                    if(res==NULL)
                    {
                        printf("Compilation Error ::  Varribale %s is not declared\n",$1);
                        exit(-1);
                    }
                    else 
                    {
                        $$ = res->data.intval;
                        printf("%d\n",$$);
                    }
                }
            | expression PLUS expression
                {
                    $$ = $1+$3;
                    printf("came here plus %d\n",$$);
                }
            | expression MINUS expression 
                {
                    $$ = $1-$3;
                }
            | expression MULT expression 
                {
                    $$ = $1*$3;
                }
            | expression DIV expression 
                {
                    $$ = $1/$3;
                }
            | expression LT expression 
                {
                    $$ = ($1<$3);
                }
            | expression GT expression 
                {
                    printf("GT :: %d %d\n",$1,$3);
                    $$ = ($1>$3);
                }
            | expression LE expression 
                {
                    printf("LE :: %d %d\n",$1,$3);
                    $$ = ($1<=$3);
                    printf("LE res :: %d\n",$$);
                }
            | expression GE expression 
                {
                    $$ = ($1>=$3);
                }
            | expression EQU expression 
                {
                    $$ = ($1==$3);
                }
            | expression NEQU expression 
                {
                    $$ = ($1!=$3);
                }
            | PB expression PE 
                {
                    $$ = $2;
                }
            ;

ifelse      : IF PB expression PE BB statement BE elseif 
                {
                    printf("came here ifelse %d\n",$3);
                    
                    /*if(ifptr<0){
                        printf("1ok negetive");
                        ifptr=0;
                    }
                    ifdone[ifptr] = 0;
                    ifptr --;*/
                }
            ;
elseif : /* empty */
        | ELSEIF PB expression PE BB statement BE elseif
            {
                printf("ELSE IF :: %d\n",$3);
            }
        | elseif ELSE BB statement BE 
            {
                printf("Came ELSE\n");
                /*
                if(ifptr<0){
                    printf("4ok negetive");
                    ifptr=0;
                }
                if(ifdone[ifptr] == 0) 
                {
                    printf("\n ELSE Executed\n");
                    ifdone[ifptr] = 1;
                }*/
            }
        ;

function    : /* empty */
            | function func
            ;
func        : type FUNCTION PB fparameter PE BB statement BE 
                {
                    printf("\nfunction declared\n");
                }
            ;
fparameter  : /* empty */
            | type ID fsparameter
            ;
fsparameter : /* empty */
            | fsparameter CM type ID 
            ;
%%

int yyerror(char *s){
    printf("Line %d :: %s \n",yylval.lineval,s);
}