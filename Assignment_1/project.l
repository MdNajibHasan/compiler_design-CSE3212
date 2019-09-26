digit [0-9]
letter [a-z|A-Z]
special [$_@]
space " "
newline "\n"
Datatype "int"|"double"|"char"|"void"
Operator "="|"+"|"-"|"/"|"*"|"&"|"|"|"%"
Releational_Operator ">"|"<"|"<="|">="|"&&"|"||"|"=="|"!="
All_Operator {Operator}|{Releational_Operator}
KEYWORD "include"|"define"|{Datatype}|"return"|"if"|"else"|"elif"|"loop"|"while" 
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
    int idx[7]={0};
    int visi[2009];
    char out[7][200][200];
    int key[25]={0};
    //0 header 1 function 2 varriable  3 array 4 operator 5 punctuation 6 keyword 
    int ifok=0,elifok=0;
    int multi=0;
    int minx(int x,int y){
        if(x<=y)return x;
        return y;
    }
    int isKeyword(char *c){
        if(!strcmp("return",c) || !strcmp("include",c) || !strcmp("define",c) || !strcmp("int",c)|| !strcmp("double",c)|| !strcmp("char",c)|| !strcmp("void",c)|| !strcmp("if",c)|| !strcmp("elif",c)|| !strcmp("else",c)|| !strcmp("loop",c)|| !strcmp("while",c) )
            return 1;
        return 0;
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
    void getKeyword(char *yytext){
        char temp[109];
        for(int i=0;i<strlen(yytext);i++){
            for(int j=i+1;j<=strlen(yytext);j++){
                if(yytext[j]=='\n' || yytext[j]==' ' || yytext[j]=='(' || yytext[j]==';'|| yytext[j]==','){
                    int id=0;
                    int k=i;
                    while(k<j && (yytext[k]==' '))k++;
                    int l=j-1;
                    while(l>=k && (yytext[l]==' '))l--;
                    for(;k<=l;k++){
                        temp[id++]=yytext[k];
                    }
                    temp[id]='\0';
                    if(strlen(temp)){
                        //printf("DEBUG :: %s\n",temp);
                        //printf("%d\n",strcmp("define",temp));
                    }
                    if(isKeyword(temp)){
                        i=j-1;
                        memcpy(out[6][idx[6]++],temp,strlen(temp));
                        break;
                    }
                }
            }
        }
    }
    void getopt(char *yytext){
        memset(visi,0,sizeof visi);
        for(int i=1;i<strlen(yytext);i++){
            if(yytext[i]=='=' && yytext[i-1]=='=' && visi[i]==0 && visi[i-1]==0){
                out[4][idx[4]][0]=yytext[i-1];
                out[4][idx[4]++][1]=yytext[i];
                visi[i]=1;
                visi[i-1]=1;
            }
            if(yytext[i]=='!' && yytext[i-1]=='=' && visi[i]==0 && visi[i-1]==0){
                out[4][idx[4]][0]=yytext[i-1];
                out[4][idx[4]++][1]=yytext[i];
                visi[i]=1;
                visi[i-1]=1;
            }
            if(yytext[i]=='<' && yytext[i-1]=='=' && visi[i]==0 && visi[i-1]==0){
                out[4][idx[4]][0]=yytext[i-1];
                out[4][idx[4]++][1]=yytext[i];
                visi[i]=1;
                visi[i-1]=1;
            }
            if(yytext[i]=='>' && yytext[i-1]=='=' && visi[i]==0 && visi[i-1]==0){
                out[4][idx[4]][0]=yytext[i-1];
                out[4][idx[4]++][1]=yytext[i];
                visi[i]=1;
                visi[i-1]=1;
            }
            if(yytext[i]=='&' && yytext[i-1]=='&' && visi[i]==0 && visi[i-1]==0){
                out[4][idx[4]][0]=yytext[i-1];
                out[4][idx[4]++][1]=yytext[i];
                visi[i]=1;
                visi[i-1]=1;
            }
            if(yytext[i]=='|' && yytext[i-1]=='|' && visi[i]==0 && visi[i-1]==0){
                out[4][idx[4]][0]=yytext[i-1];
                out[4][idx[4]++][1]=yytext[i];
                visi[i]=1;
                visi[i-1]=1;
            }
        }
        for(int i=0;i<strlen(yytext);i++){
            if(visi[i]==0 && (yytext[i]=='='||yytext[i]=='+'||yytext[i]=='-'||yytext[i]=='/'||yytext[i]=='*'||yytext[i]=='&'||yytext[i]=='|'||yytext[i]=='%'||yytext[i]=='>'||yytext[i]=='<')){
                out[4][idx[4]++][0]=yytext[i];
                visi[i]=1;
            }
            if(visi[i]==0 && (yytext[i]=='#'||yytext[i]==';'||yytext[i]==')'|| yytext[i]=='('||yytext[i]=='}'||yytext[i]=='{'||yytext[i]==']'||yytext[i]=='[')){
                out[5][idx[5]++][0]=yytext[i];
                visi[i]=1;
            }   
        }
       

    }
    // 1 2 3 4 5 6 7 8 9 10 11 12 13 14
    //0 header 1 function 2 varriable  3 array 4 operator
%}
%%

[/][/].* {printf("Comment found\n");}
"/*".* {
    if(multi==0)printf("multiComment found\n");multi=1;
}
"*/" {
    if(multi){
        printf("multi Comment ended\n");
        multi=0;
    }
    else{
        printf("%s",yytext);
    }
}
"#include"[ ]{HEADER}+ {
    if(multi==0){
        key[0]=1;
        printf("Header Included :: \n");
        int cc = 1;
        int br=0;
        int id=0;
	    printf("Header %d :: ", cc++);
        int prev=idx[0];
        for (int i = 9; i < strlen(yytext); i++) {
            if (yytext[i] == ',') {
                out[0][idx[0]][id]='\0';
                id=0;
                if(isKeyword(out[0][idx[0]])){
                    printf("ERROR :: KEYWORD USED\n");
                    continue;
                }
                idx[0]++;
                printf("\nHeader %d :: ", cc++);
                continue;
            }
		    if (yytext[i] == ';'){
                if(isKeyword(out[0][idx[0]])){
                    printf("ERROR :: KEYWORD USED\n");
                    continue;
                }
                idx[0]++;
                br=1;
                break;
            }
            out[0][idx[0]][id++]=yytext[i];
            printf("%c", yytext[i]);
        }
        getopt(yytext);
        getKeyword(yytext);
        if(br==0){
            idx[0]=prev;
            printf("Error :: Expected semicolon");
        }
    }
}
"#include".* {
    if(multi==0){
        printf("Error :: Header not included or not found");
    }
}
"#define "{KEYWORD}[(][)] {
    if(multi==0)
        printf("Error :: Cannot define function name using KEYWORD\n");
}
"#define "{_DECLARE_FUNCTION_} {
    if(multi==0){
        out[6][idx[6]][0]='d';
        out[6][idx[6]][1]='e';
        out[6][idx[6]][2]='f';
        out[6][idx[6]][3]='i';
        out[6][idx[6]][4]='n';
        out[6][idx[6]][5]='e';
        out[6][idx[6]][6]='\0';
        idx[6]++;
    key[1]=1;
    int id=0;
    int i;
    printf("function Declared :: ");
    for(i=8;i<strlen(yytext);i++){
        if(yytext[i]=='(')break;
        printf("%c",yytext[i]);
        out[1][idx[1]][id++]=yytext[i];
    }
    int br=0;
    while(i<strlen(yytext)){
        if(yytext[i]==')'){br=1;break;}
        i++;
    }
    if(br==0){
        printf("Error :: Expected ')'\n");
        getopt(yytext);
        getKeyword(yytext);
    }
    else{
        idx[1]++;
        funst=1;
    }
    printf("\n");
    }
}
"#define ".* {
    if(multi==0){
        printf("ERROR :: CANT DECLARE FUNCTION\n");
    }
}
{Datatype}{space}({varriable}("="{digit}*){0,1},{0,1})+";" {
    if(multi==0){
    printf("match 1\n");
    int i;
    char temp[10];
    for(i=0;i<strlen(yytext);i++){
        if(yytext[i]==' ')break;
        printf("%c",yytext[i]);
        temp[i]=yytext[i];
    }
    
    // if(temp[0]=='i' && temp[1]=='n' && temp[2]=='t')key[2]=1;
    // if(temp[0]=='d' && temp[1]=='o' && temp[2]=='u' && temp[3]=='b' && temp[4]=='l' && temp[5]=='e')key[3]=1;
    // if(temp[0]=='c' && temp[1]=='h' && temp[2]=='a' && temp[3]=='r')key[4]=1;
    // if(temp[0]=='v' && temp[1]=='o' && temp[2]=='i' && temp[3]=='d')key[5]=1;
    int cc=1;
    int id=0;
    printf(" Type Data Declared :: \nVar %d=",cc++);
    int ok=1;
    i++;
    for(;i<strlen(yytext);i++){
        if(yytext[i]==',' || yytext[i]==';' || yytext[i]=='='){
            out[2][idx[2]][id]='\0';
            id=0;
            ok=0;
            if(isKeyword(out[2][idx[2]])){
                printf("ERROR :: KEYWORD USED\n");
                continue;
            }
            idx[2]++;
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
    getKeyword(yytext);
    }
}

{Datatype}{space}({_ARRAY_},{0,1})*";" {
    if(multi==0){
    printf("match 2\n");
    int i;
    char temp[10];
    for(i=0;i<strlen(yytext);i++){
        if(yytext[i]==' ')break;
        printf("%c",yytext[i]);
        temp[i]=yytext[i];
    }
    // if(temp[0]=='i' && temp[1]=='n' && temp[2]=='t')key[2]=1;
    // if(temp[0]=='d' && temp[1]=='o' && temp[2]=='u' && temp[3]=='b' && temp[4]=='l' && temp[5]=='e')key[3]=1;
    // if(temp[0]=='c' && temp[1]=='h' && temp[2]=='a' && temp[3]=='r')key[4]=1;
    // if(temp[0]=='v' && temp[1]=='o' && temp[2]=='i' && temp[3]=='d')key[5]=1;
    int cc=1;
    int id=0;
    printf(" Type array Declared :: \nArray %d=",cc++);
    int ok=1;
    i++;
    for(;i<strlen(yytext);i++){
        if(yytext[i]=='['){
            out[3][idx[3]][id]='\0';
            id=0;
            ok=0;
            if(isKeyword(out[3][idx[3]])){
                printf("ERROR :: KEYWORD USED\n");
                continue;
            }
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
    getKeyword(yytext);
    }
}
"else" {
    if(multi==0){
    printf("Else found\n");
    out[6][idx[6]][0]='e';
    out[6][idx[6]][1]='l';
    out[6][idx[6]][2]='s';
    out[6][idx[6]][3]='e';
    out[6][idx[6]][4]='\0';
    idx[6]++;
    if(!ifok && !elifok){
        printf("Error :: without elif\n");
    }
    else {
        elifok=0;
        ifok=0;
        findelse=0;
    }
    }
}
"elif("{_EXPRESSION_}")" {
    if(multi==0){
    printf("Else if _EXPRESSION_ found\n");
    getKeyword(yytext);
    out[6][idx[6]][0]='e';
    out[6][idx[6]][1]='l';
    out[6][idx[6]][2]='i';
    out[6][idx[6]][3]='f';
    out[6][idx[6]][4]='\0';
    idx[6]++;
    if(!ifok && !elifok){
        printf("Error :: without if ");
    }else{
        elifok=1;
        ifok=0;
        findelif=0;
    }
    getopt(yytext);
    }
}
"if("{_EXPRESSION_}")" {
    if(multi==0){
    out[6][idx[6]][0]='i';
    out[6][idx[6]][1]='f';
    out[6][idx[6]][3]='\0';
    idx[6]++;
    printf("If_EXPRESSION_ found\n");
    getopt(yytext);
    getKeyword(yytext);
    memcpy(out[6][idx[6]++],"if",2);
    findif=0;
    }
}
"loop("{space}*({_EXPRESSION_},*)*";"({_EXPRESSION_},*)*";"({_EXPRESSION_},*)*.*")" {
    if(multi==0){
        printf("loop found");
        getopt(yytext);
    getKeyword(yytext);
    out[6][idx[6]][0]='l';
    out[6][idx[6]][1]='o';
    out[6][idx[6]][2]='o';
    out[6][idx[6]][3]='p';
    out[6][idx[6]][4]='\0';
    idx[6]++;
    }
}
"while("{_EXPRESSION_}")" {
    if(multi==0){
        printf("While loop found\n");
        out[6][idx[6]][0]='w';
        out[6][idx[6]][1]='h';
        out[6][idx[6]][2]='i';
        out[6][idx[6]][3]='l';
        out[6][idx[6]][4]='e';
        out[6][idx[6]][5]='\0';
        idx[6]++;
        getKeyword(yytext);
        getopt(yytext);
    }
}
{KEYWORD}[(][)]";" {
    if(multi==0)
        printf("Error :: Called function is a keyword\n");
}
{_CALL_FUNCTION_}";" {
    if(multi==0){
        printf("function called :: ");
        int id=0;
        for(int i=0;i<strlen(yytext);i++){
            if(yytext[i]=='(')break;
            printf("%c",yytext[i]);
            out[1][idx[1]][id++]=yytext[i];
        }
        getKeyword(yytext);
        getopt(yytext);
        idx[1]++;
        printf("\n");
    }
}
["{"] {
    if(multi==0){
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
}
["}"] {
    if(multi==0){
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
}
.|{newline} {
    if(multi==0){
        if(funst==0)
            printf("%s",yytext);
        getopt(yytext);
        getKeyword(yytext);
    }
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
    printf("\n\n===============================\n");
    printf(":: Header list :: %d\n",idx[0]);
    int taken=0;
    for(int i=0;i<idx[0];i++){
        if(strlen(out[0][i]) && out[0][i][0]!='\n'){
        taken=1;
        for(int j=0;j<i;j++){
            if(strcmp(out[0][j],out[0][i])==0){
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
        if(strlen(out[1][i]) && out[1][i][0]!='\n'){
        taken=1;
        for(int j=0;j<i;j++){
            if(strcmp(out[1][j],out[1][i])==0){
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
        if(strlen(out[2][i]) && out[2][i][0]!='\n'){
        taken=1;
        for(int j=0;j<i;j++){
            if(strcmp(out[2][j],out[2][i])==0){
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
        if(strlen(out[3][i]) && out[3][i][0]!='\n'){
        taken=1;
        for(int j=0;j<i;j++){
            if(strcmp(out[3][j],out[3][i])==0){
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
        if(strlen(out[4][i]) && out[4][i][0]!='\n'){
        taken=1;
        for(int j=0;j<i;j++){
            if(strcmp(out[4][j],out[4][i])==0){
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
        if(strlen(out[5][i]) && out[5][i][0]!='\n'){
        taken=1;
        for(int j=0;j<i;j++){
            if(strcmp(out[5][j],out[5][i])==0){
                taken=0;
                break;
            }
        }
        if(taken){
            printf("%s\n",out[5][i]);
        }
    }
    }
    printf(":: KEYWORD list :: %d\n",idx[6]);
    taken=0;
    for(int i=0;i<idx[6];i++){
        if(strlen(out[6][i]) && out[6][i][0]!='\n'){
        taken=1;
        for(int j=0;j<i;j++){
            if(strcmp(out[6][j],out[6][i])==0){
                taken=0;
                break;
            }
        }
        if(taken){
            printf("%s\n",out[6][i]);
        }
    }
    }
    return 0;
}