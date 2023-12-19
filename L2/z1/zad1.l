%{
  #include <stdio.h>
  int words = 0;
  int lines = 1;
%}

%%
^[ \t]+[^ \t\n]  {printf("%c", yytext[yyleng-1]);}             
[ \t]$             
^\n
[\n]+[ \t]*[^ \t\n]   {printf("\n%c", yytext[yyleng-1]); lines++;}               
[ \t]+[^ \t\n]  {printf(" %c", yytext[yyleng-1]); words++;}    
[\n]+              
[ \t]+ 
%% 

int yywrap(){}

int main(){
  yylex();
  fprintf(stderr, "\n\n%d lines, %d words", lines, words+lines);
  return 0;
}