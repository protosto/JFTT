flex z1.l &&
bison -d -t z1.y &&
g++ lex.yy.c z1.tab.c -o z1 &&
rm lex.yy.c