digit [0-9]
letter [a-z|A-Z]
special [$_@]
space " "
newline "\n"
Datatype "int"|"double"|"char"|"void"
Operator "="|"+"|"-"|"/"|"*"|"&"|"|"|"%"
Releational_Operator ">"|"<"|"<="|">="|"&&"|"||"|"=="|"!="
All_Operator {Operator}|{Releational_Operator}
KEYWORD "include"|"define"|{Datatype}|"return"|"if"|"else"|"elif"|"loop"|"while"|"run"|"new" 
HEADER [a-z|A-Z]+.h[,|;]
varriable [a-z|A-Z]+[a-z|A-Z|0-9]*
_ARRAY_ {varriable}"["{digit}*"]"
_DECLARE_VAR_ {Datatype}{space}{varriable}
_VAR_ASSIGN_ {varriable}"="{digit}+
_VALUE_ {varriable}|{digit}+
_DECLARE_FUNCTION_ {varriable}"("({_DECLARE_VAR_},{0,1})*")"
_CALL_FUNCTION_ {varriable}"("({_VALUE_},{0,1})*")"
_EXPRESSION_ {_VALUE_}{All_Operator}{_VALUE_}
%{
    #include<string.h>
    #include<stdio.h>
    int funst=0;
    int findif=-1,findelif=-1,findelse=-1;
    int idx[6]={0};
    //char keyw[20]={"include","define","int","double","char","void","return","if","else","elif","loop","while","run","new"};
    //memset(idx,-1,sizeof (idx));
    char out[6][200][200];
    int key[25]={0};
    //memset(key,-1,sizeof(key));
    int ifok=0,elifok=0;
    int minx(int x,int y){
        if(x<=y)return x;
        return y;
    }
    int comp(char *c,char *d){
        int ok=1;
        int l1=strlen(d),l2=strlen(c);
        if(l1!=l2)return 0;
        for(int i=0;i<minx(l1,l2);i++){
            if(c[i]<d[i])return -1;
            if(c[i]>d[i])return 0;
        }
        return 1;
    }
  
    void assign_(int id,int from,int to){
        for(int i=0;i<=strlen(out[id][from]);i++){
            out[id][to][i]=out[id][from][i];
        }
    }
    void getopt(char *yytext){
        for(int i=0;i<strlen(yytext);i++){
            if(yytext[i]=='='||yytext[i]=='+'||yytext[i]=='-'||yytext[i]=='/'||yytext[i]=='*'||yytext[i]=='&'||yytext[i]=='|'||yytext[i]=='%'||yytext[i]=='>'||yytext[i]=='<'){
                out[4][idx[4]++][0]=yytext[i];
            }
            if(yytext[i]=='#'||yytext[i]==';'||yytext[i]==')'|| yytext[i]=='('||yytext[i]=='}'||yytext[i]=='{'||yytext[i]==']'||yytext[i]=='['){
                out[5][idx[5]++][0]=yytext[i];
            }
            
        }
        for(int i=1;i<strlen(yytext);i++){
            if(yytext[i]=='=' && yytext[i-1]=='='){
                out[4][idx[4]][0]=yytext[i-1];
                out[4][idx[4]++][1]=yytext[i];
            }
            if(yytext[i]=='!' && yytext[i-1]=='='){
                out[4][idx[4]][0]=yytext[i-1];
                out[4][idx[4]++][1]=yytext[i];
            }
            if(yytext[i]=='<' && yytext[i-1]=='='){
                out[4][idx[4]][0]=yytext[i-1];
                out[4][idx[4]++][1]=yytext[i];
            }
            if(yytext[i]=='>' && yytext[i-1]=='='){
                out[4][idx[4]][0]=yytext[i-1];
                out[4][idx[4]++][1]=yytext[i];
            }
            if(yytext[i]=='&' && yytext[i-1]=='&'){
                out[4][idx[4]][0]=yytext[i-1];
                out[4][idx[4]++][1]=yytext[i];
            }
            if(yytext[i]=='|' && yytext[i-1]=='|'){
                out[4][idx[4]][0]=yytext[i-1];
                out[4][idx[4]++][1]=yytext[i];
            }
        }

    }
    // 1 2 3 4 5 6 7 8 9 10 11 12 13 14
    //0 header 1 function 2 varriable  3 array 4 operator
%}
%%
"//".* {printf("Comment found\n");}
"#include"[ ]{HEADER}+ {
    key[0]=1;
    printf("Header Included :: \n");
    int cc = 1;
    int br=0;
    int id=0;
	printf("Header %d :: ", cc++);
    int prev=idx[0];
    for (int i = 9; i < strlen(yytext); i++) {
        if (yytext[i] == ',') {
            id=0;
            idx[0]++;
            printf("\nHeader %d :: ", cc++);
            continue;
        }
		if (yytext[i] == ';'){
                idx[0]++;
                br=1;
                break;
        }
        out[0][idx[0]][id++]=yytext[i];
        printf("%c", yytext[i]);
    }
    getopt(yytext);
    if(br==0){
        idx[0]=prev;
        printf("Error :: Expected semicolon");
    }
}
"#include".* {printf("Error :: Header not included or not found");}
"#define "{KEYWORD}[(][)] {printf("Error :: Cannot define function name using KEYWORD\n");}
"#define "{_DECLARE_FUNCTION_} {
    key[1]=1;
    int id=0;
    printf("function Declared :: ");
    for(int i=8;i<strlen(yytext);i++){
        if(yytext[i]=='(')break;
        printf("%c",yytext[i]);
        out[1][idx[1]][id++]=yytext[i];
    }
    idx[1]++;
    funst=1;
    printf("\n");
    getopt(yytext);
}
"#define ".* {
    printf("ERROR :: CANT DECLARE FUNCTION\n");
}
{Datatype}{space}({varriable}("="{digit}*){0,1},{0,1})+";" {
    printf("match 1\n");
    int i;
    char temp[10];
    for(i=0;i<strlen(yytext);i++){
        if(yytext[i]==' ')break;
        printf("%c",yytext[i]);
        temp[i]=yytext[i];
    }
    if(temp[0]=='i' && temp[1]=='n' && temp[2]=='t')key[2]=1;
    if(temp[0]=='d' && temp[1]=='o' && temp[2]=='u' && temp[3]=='b' && temp[4]=='l' && temp[5]=='e')key[3]=1;
    if(temp[0]=='c' && temp[1]=='h' && temp[2]=='a' && temp[3]=='r')key[4]=1;
    if(temp[0]=='v' && temp[1]=='o' && temp[2]=='i' && temp[3]=='d')key[5]=1;
    int cc=1;
    int id=0;
    printf(" Type Data Declared :: \nVar %d=",cc++);
    int ok=1;
    i++;
    for(;i<strlen(yytext);i++){
        if(yytext[i]==',' || yytext[i]==';' || yytext[i]=='='){
            id=0;
            ok=0;
            idx[2]++;
            if(yytext[i]=='=')out[4][idx[4]++][0]='=';
        }
        if(yytext[i]==','){
            ok=1;
            printf("\nVar %d=",cc++);
        }
        else if(ok){
            out[2][idx[2]][id++]=yytext[i];
            printf("%c",yytext[i]);
        }
    }
    printf("\n");
    getopt(yytext);
}

{Datatype}{space}({_ARRAY_},{0,1})*";" {
    printf("match 2\n");
    int i;
    char temp[10];
    for(i=0;i<strlen(yytext);i++){
        if(yytext[i]==' ')break;
        printf("%c",yytext[i]);
        temp[i]=yytext[i];
    }
    if(temp[0]=='i' && temp[1]=='n' && temp[2]=='t')key[2]=1;
    if(temp[0]=='d' && temp[1]=='o' && temp[2]=='u' && temp[3]=='b' && temp[4]=='l' && temp[5]=='e')key[3]=1;
    if(temp[0]=='c' && temp[1]=='h' && temp[2]=='a' && temp[3]=='r')key[4]=1;
    if(temp[0]=='v' && temp[1]=='o' && temp[2]=='i' && temp[3]=='d')key[5]=1;
    int cc=1;
    int id=0;
    printf(" Type array Declared :: \nArray %d=",cc++);
    int ok=1;
    i++;
    for(;i<strlen(yytext);i++){
        if(yytext[i]=='['){
            ok=0;
            id=0;
            idx[3]++;
        }
        if(yytext[i]==','){
            ok=1;
            id=0;
            printf("\nArray %d=",cc++);
        }
        else if(ok){
            out[3][idx[3]][id++]=yytext[i];
            printf("%c",yytext[i]);
        }
    }
    printf("\n");
    getopt(yytext);
}
"else" {
    printf("Else found\n");
    if(!ifok && !elifok){
        printf("Error :: without elif\n");
    }
    else {
        elifok=0;
        ifok=0;
        findelse=0;
    }
}
"elif("{_EXPRESSION_}")" {
    printf("Else if _EXPRESSION_ found\n");
    if(!ifok && !elifok){
        printf("Error :: without if ");
    }else{
        elifok=1;
        ifok=0;
        findelif=0;
    }
    getopt(yytext);
}
"if("{_EXPRESSION_}")" {
    printf("If_EXPRESSION_ found\n");
    
    
    getopt(yytext);
    findif=0;
}
"loop("{space}*({_EXPRESSION_},*)*";"({_EXPRESSION_},*)*";"({_EXPRESSION_},*)*.*")" {
    printf("loop found");
    getopt(yytext);
}
"while("{_EXPRESSION_}")" {
    printf("While loop found\n");
    getopt(yytext);
}
{_CALL_FUNCTION_}";" {
    printf("function called :: ");
    int id=0;
    for(int i=0;i<strlen(yytext);i++){
        if(yytext[i]=='(')break;
        printf("%c",yytext[i]);
        out[1][idx[1]][id++]=yytext[i];
    }
    idx[1]++;
    printf("\n");
}
["{"] {
   // printf("match {\n");
    if(findif==0){
        findif=1;
    }
    else if(findelif==0){
        findelif=1;
    }
    else if(findelse==0){
        findelse=1;
    }
    else if(funst==0){
        printf("%s",yytext);
    }
}
["}"] {
    if(findif==1){
        findif=-1;
        ifok=1;
    }
    else if(findelif==1){
        findelif=-1;
        elifok=1;
        ifok=0;
    }
    else if(findelse==1){
        findelse=-1;
        ifok=0;
        elifok=0;
    }
    else if(funst){
        funst=0;
    }
    else if(funst==0){
        printf("%s",yytext);
    }
}
.|{newline} {
    if(funst==0){
        printf("%s",yytext);
    }
    
    getopt(yytext);
}

%%

int yywrap()
{
    return 1;
}
int main(){
    freopen("input.nuhash.txt","r",stdin);
    freopen("output.txt","w",stdout);
    yylex();
    //0 header 1 function 2 varriable  3 array
    //printf("%d\n",keyw_cnt);
    printf("\n\n===============================\n");
    printf(":: Header list :: %d\n",idx[0]);
    int taken=0;
    for(int i=0;i<idx[0];i++){
        if(strlen(out[0][i])){
        taken=1;
        for(int j=0;j<i;j++){
            if(comp(out[0][j],out[0][i])==1){
                taken=0;
                break;
            }
        }
        if(taken){
            printf("%s\n",out[0][i]);
        }
    }
    }
    //0 header 1 function 2 varriable  3 array 4 operator
    printf(":: FUNCTION list :: %d\n",idx[1]);
    taken=0;
    for(int i=0;i<idx[1];i++){
        if(strlen(out[1][i])){
        taken=1;
        for(int j=0;j<i;j++){
            if(comp(out[1][j],out[1][i])==1){
                taken=0;
                break;
            }
        }
        if(taken){
            printf("%s\n",out[1][i]);
        }
    }
    }
    printf(":: varriable list :: %d\n",idx[2]);
    taken=0;
    for(int i=0;i<idx[2];i++){
        if(strlen(out[2][i])){
        taken=1;
        for(int j=0;j<i;j++){
            if(comp(out[2][j],out[2][i])==1){
                taken=0;
                break;
            }
        }
        if(taken){
            printf("%s\n",out[2][i]);
        }
    }
    }
    printf(":: array list :: %d\n",idx[3]);
    taken=0;
    for(int i=0;i<idx[3];i++){
        if(strlen(out[3][i])){
        taken=1;
        for(int j=0;j<i;j++){
            if(comp(out[3][j],out[3][i])==1){
                taken=0;
                break;
            }
        }
        if(taken){
            printf("%s\n",out[3][i]);
        }
    }
    }
    printf(":: Operator list :: %d\n",idx[4]);
    taken=0;
    for(int i=0;i<idx[4];i++){
        if(strlen(out[4][i])){
        taken=1;
        for(int j=0;j<i;j++){
            if(comp(out[4][j],out[4][i])==1){
                taken=0;
                break;
            }
        }
        if(taken){
            printf("%s\n",out[4][i]);
        }
    }
    }
    
    printf(":: Punctuation list :: %d\n",idx[5]);
    taken=0;
    for(int i=0;i<idx[5];i++){
        if(strlen(out[5][i])){
        taken=1;
        for(int j=0;j<i;j++){
            if(comp(out[5][j],out[5][i])==1){
                taken=0;
                break;
            }
        }
        if(taken){
            printf("%s\n",out[5][i]);
        }
    }
    }
    return 0;
}
