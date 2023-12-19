%{
#include <stdio.h>
#include <stdbool.h>

int yywrap();
int yylex();
bool doc = false;

%}
%option yylineno

%x SINGLECOMMENT
%x MULTICOMMENT
%x STRING
%x INCLUDE
%x SINGLEDOC
%x MULTIDOC


%%

\<            ECHO; BEGIN(INCLUDE);
<INCLUDE>{
  \>          ECHO; BEGIN(0);
}

\"            ECHO; BEGIN(STRING);
<STRING>{
  \"          ECHO; BEGIN(0);
}

\/(\\(\r)?\n)?\/          BEGIN(SINGLECOMMENT);
<SINGLECOMMENT>{
.             ;
\\(\r)?\n      ;
\\\r      ;
\n        {BEGIN(0); }
}

\/\*          BEGIN(MULTICOMMENT);
<MULTICOMMENT>{
  .             ;
  \*\/          BEGIN(0);
}

\/\/\/        BEGIN(SINGLEDOC);
\/\/!         BEGIN(SINGLEDOC);
<SINGLEDOC>{
.             if(doc) ECHO;
\\\n     if(doc) ECHO ;
\n        if(doc) ECHO; BEGIN(0);  
}

\/\*\*          BEGIN(MULTIDOC);
\/\*!          BEGIN(MULTIDOC);
<MULTIDOC>{
  .            if(doc) ECHO;
  \*\/          if(doc) ECHO; BEGIN(0);
}



%%

int yywrap() {
    return 1;
}

int main() {
    return yylex();
}