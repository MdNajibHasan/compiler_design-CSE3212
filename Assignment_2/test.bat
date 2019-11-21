bison -d comp_bison.y
flex comp_lex.l 
gcc lex.yy.c comp_bison.tab.c -o test
test