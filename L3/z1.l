%{
#include <stdio.h>
#include <stdlib.h>
#include "z1y.hpp"
#define p 1234577

extern int yylex();
%}

%option noyywrap

%x COMMENT
%x ERROR


%%
^#                              BEGIN(COMMENT);
\\\n                            ;
[ \t]+                          ;
<COMMENT>{
    .|\\\n                      ;
    \n                          BEGIN(0);
}
\n                              return '\n';
[0-9]+                          { yylval = atoi(yytext) % p; return NUM; }
\+                              return '+';
\-                              return '-';
\*                              return '*';
\/                              return '/';
\^                              return '^';
\(                              return '(';
\)                              return ')';
.                               { BEGIN(ERROR); return ERR; } 
<ERROR>{
    \n                          { BEGIN(0); return '\n'; }
    .                           ;
}
%%