bison -d proj.y
flex proj.l
gcc lex.yy.c proj.tab.c -o app
app