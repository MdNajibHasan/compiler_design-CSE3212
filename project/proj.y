%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include<math.h>
    #include "identifier.c"
    int yyparse();
    int yylex();
    int yyerror();
    int ifdone[1000];
    int ifptr=0;
    int dimencount = 0;
    struct ll_identifier *root=NULL,*last=NULL;
    int typenow = -1;
%}
%code requires {
    #ifndef __DT__
    #define __DT__
    struct __DT__ datatype {
        int type;
        char *strval;
        int intval;
        double doubleval;
    };
    #endif
}
%union {
    char text[1009];
    struct datatype val;
}

%token<text>NAME
%token<text>VARACCESS
%token<val>NUM
%token<val>STR
%type<val>expression

%token FUNC CLASS INIT INT DOUBLE STRING CONST VOID VAR
%token ELSEIF ELSE IF
%token FOR WHILE DO
%token CONTINUE RETURN
%token RIGHT_ASSIGN LEFT_ASSIGN ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN RIGHT_OP LEFT_OP INC_OP DEC_OP PTR_OP 
%token AND_OP OR_OP LE_OP GE_OP EQ_OP NE_OP

%%
starthere   : /* empty */
            | function starthere
            | declaration starthere
            | classgrammer starthere
            ;

classgrammer    : CLASS NAME '{' statement '}' ';' {
                    int res = addNewClass(&root,&last,$2,"");
                    if(!res)
                    {
                        printf("Compilation Error ::  this name :: %s is already declared\n",$2);
                        exit(-1);
                    }
                    else{
                        printf("Class declared\n");
                    }
                }
                ;

function    : FUNC NAME '(' fparameter ')' PTR_OP TYPE {
                char *val;
                int n = log10(typenow) + 1;
                val = calloc(n + 1, sizeof(char));
                snprintf(val, n, "%ld", typenow);
                int res = addNewFunc(&root,&last,$2,val);
                if(!res)
                {
                    printf("Compilation Error ::  Varribale %s is already declared\n",$2);
                    exit(-1);
                }
                else{
                    printf("Function declared\n");
                }
            } '{' statement '}'
            ;
TYPE        : INT { typenow = 1;}
            | DOUBLE { typenow = 2;}
            | STRING { typenow = 3;}
            | VOID { typenow = 4;}
            | NAME {  
                struct ll_identifier* res = getVal(&root,$1);
                if(res==NULL || res->data.type!=6){
                    printf("Error :: Class Name Not defined\n");
                    exit(-1);
                }
                typenow = res->data.intval;
            }
            ;
fparameter : 
            | NAME ':' TYPE fsparameter
            ;
fsparameter :
            | ',' NAME ':' TYPE fsparameter
            | ',' NAME ':' TYPE
            ;
statement   :
            | ifgrammer statement
            | declaration statement
            | forgrammer statement
            | asgngrammer statement
            | whilegrammer statement
            | mathexpr statement
            | dowhilegrameer statement
            | returnstmt statement
            ;

mathexpr    : expression ';'
            ;
ifgrammer   : IF '(' expression ')' '{' statement '}' elsifgrmr
            ;
expression  : NUM { $$ = $1;
                     print_datatype($1);
            }
            | STR {
                $$ = $1; print_datatype($1);
            }
            | VARACCESS {
                struct ll_identifier* res = isDeclared(&root,$1);
                if(res==NULL)
                {
                    printf("Compilation Error ::  Varribale %s is not declared\n",$1);
                    exit(-1);
                }
                else if(res->data.type == 1 || res->data.type == 6)
                {
                    printf("Error :: You can't set a value to class/function");
                    exit(-1);
                }
                else 
                {
                    if(res->data.type==2)
                        $$ = make_datatype_int(res->data.intval);
                    else if(res->data.type==3)
                        $$ = make_datatype_double(res->data.doubleval);
                    else if(res->data.type==4){
                        $$ = make_datatype_char(res->data.strval);
                    }
                }
            }
            | expression '+' expression { 
                $$ = evaluate($1,$3,"+");
            }
            | expression '-' expression { 
                $$ = evaluate($1,$3,"-");
            }
            | expression '/' expression { 
                $$ = evaluate($1,$3,"/");
            }
            | expression '*' expression { 
                $$ = evaluate($1,$3,"*");
            }
            | expression "<=" expression { 
                $$ = evaluate($1,$3,"<=");
            }
            | expression ">=" expression { 
                $$ = evaluate($1,$3,">=");
            }
            | expression '<' expression { 
                $$ = evaluate($1,$3,"<");
            }
            | expression '>' expression { 
                $$ = evaluate($1,$3,">");
            }
            | expression "==" expression { 
                $$ = evaluate($1,$3,"==");
            }
            | expression "!=" expression { 
                $$ = evaluate($1,$3,"!=");
            }
            | '(' expression ')' { 
                $$ = $2;
            }
            ;

returnstmt  : RETURN mathexpr
            | RETURN ';'

declaration :VAR varriables ';'
            ;
varriables  : varriable ',' varriables
            | varriable
            ;
varriable   : NAME ':' TYPE {
                int res = addNewVal(&root,&last,$1,"");
                if(!res)
                {
                    printf("Compilation Error ::  Varribale %s is already declared\n",$1);
                    exit(-1);
                }
                printf("varriable declared\n");
            }
            | NAME '=' expression {
                char *val;
                if ($3.type == 2) {
                    $3.type = 4;
                    int n = log10($3.intval) + 1;
                    val = calloc(n + 1, sizeof(char));
                    snprintf(val, n + 1, "%ld", $3.intval);
                }
                else if ($3.type == 3) {
                    $3.type = 4;
                    val = calloc(51, sizeof(char));
                    snprintf(val, 50, "%lf", $3.doubleval);
                }
                else{
                    val = $3.strval;
                }
                int res = addNewVal(&root,&last,$1,val);
                if(!res)
                {
                    printf("Compilation Error ::  Varribale %s is already declared\n",$1);
                    exit(-1);
                }
                else{
                    printf("varriable declared\n");
                }
            }
            | NAME ':' arraydim '*' '(' expression ')' {
                char *val;
                //printf("dimencount :: %d\n",dimencount);
                int n = log10(dimencount) + 2;
                val = calloc(n + 1, sizeof(char));
                char *temp = calloc(n,sizeof(char));
                snprintf(temp, n, "%ld", dimencount);
                val[0]='`';
                strcat(val,temp);
                int res = addNewVal(&root,&last,$1,val);
                if(!res)
                {
                    printf("Compilation Error ::  Varribale %s is already declared\n",$1);
                    exit(-1);
                }
                else{
                    printf("Array declared\n");
                }
            }
            | NAME ':' arraydim {
                char *val;
                //printf("dimencount :: %d\n",dimencount);
                int n = log10(dimencount) + 2;
                val = calloc(n + 1, sizeof(char));
                char *temp = calloc(n,sizeof(char));
                snprintf(temp, n, "%ld", dimencount);
                val[0]='`';
                strcat(val,temp);
                int res = addNewVal(&root,&last,$1,val);
                if(!res)
                {
                    printf("Compilation Error ::  Varribale %s is already declared\n",$1);
                    exit(-1);
                }
                else{
                    printf("Array declared\n");
                }
            }
            ;
arraydim    : '[' arrayx ']' {dimencount++;}
            ;
arrayx      : TYPE {dimencount = 0;}
            | '[' arrayx ']' {dimencount++;}
            ;
elsifgrmr   :
            | ELSEIF '(' expression ')' '{' statement '}' elsifgrmr
            | ELSE '{' statement '}'
            ;
asgngrammer : ASGNVAR ',' asgngrammer
            | ASGNVAR ';'
            ;

forgrammer  : FOR '(' forassign ';' expression ';' forassign ')' '{' statement '}'
            ;

forassign   : ASGNVAR ',' forassign
            | ASGNVAR
ASGNVAR     : VARACCESS '=' expression {
                struct ll_identifier* res = isDeclared(&root,$1);
                if(res==NULL)
                {
                    printf("Compilation Error ::  Varribale %s is not declared\n",$1);
                    exit(-1);
                }
                else if(res->data.type == 1 || res->data.type == 6)
                {
                    printf("Error :: You can't set a value to class/function");
                    exit(-1);
                }
                else 
                {
                    if($3.type == 2){
                        int n = log10($3.intval) + 1;
                        char *numberArray = calloc(n, sizeof(char));
                        sprintf(numberArray,"%ld",$3.intval);
                        setVal(&root,&last,$1,numberArray);
                    }
                    else if($3.type == 3){
                        char *numberArray = calloc(51,sizeof(char));
                        snprintf(numberArray,50,"%lf",$3.doubleval);
                        setVal(&root,&last,$1,numberArray);
                    }
                    else{
                        setVal(&root,&last,$1,$3.strval);
                    }
                }
            }
            ;
        
whilegrammer    : WHILE '(' expression ')' '{' statement '}'
                ;
dowhilegrameer  : DO '{' statement '}' WHILE '(' expression ')' ';'

%%
extern char yytext[];
extern int column;
int yyerror(char *s){
    fflush(stdout);
	printf("\n%*s\n%*s\n", column, "^", column, s);
}