%{
  #include <stdio.h>
%}

%x COMMENT
%x CODE


%%
\<!--.*--.*--\>       ECHO;
\<       ECHO; BEGIN(CODE);


<CODE>{
  \".*\"      ECHO;
  .      ECHO;
  \n     ECHO;
  .\>     ECHO; BEGIN(0);
}


\<!--     BEGIN(COMMENT);
<COMMENT>{
    .|\n            ;
    --\>            BEGIN(0);
}

%% 

int yywrap(){}

int main(){
  yylex();
  return 0;
}