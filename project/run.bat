flex proj.l
bison -d proj.y
gcc lex.yy.c proj.tab.c -o app
app