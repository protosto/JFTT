%{
  #include <iostream>
  #include <stdio.h>
  #include <string>
  #include <stack>
  #include <cmath>
  using namespace std;

  int a,b;
  string msg;
  void reset();
  stack <int> tab;
%}

%x END

%%

\-?[0-9]+   tab.push(stoi(yytext));

[\+\-\*\^/%]      { 

 if (tab.size() > 1) {
        b = tab.top();
        tab.pop();
        a = tab.top();
        tab.pop();
        REJECT;
    }else {
        msg="Blad: za mala liczba argumentow";
        BEGIN(END);
    }

}

[/%]  {

  if (b == 0) {
    msg = "Błąd: dzielenie przez 0";
        BEGIN(END);
    }
    else {REJECT;}

}

[(\r?\n)<<EOF>>] {
    if (tab.size() > 1){
        msg = "Błąd: za mała liczba operatorów";
        reset();
    }
        
    if(tab.size() == 1){
        cout << "= " << tab.top() << endl;
        msg = "";
        reset();
        }
}


"+" tab.push(a+b);
"-" tab.push(a-b);
"*" tab.push(a*b);
"^" tab.push((int)pow(a,b));
"/" tab.push(a/b);
"%" tab.push(a%b);

<END>{
.*\n {
    reset();
    BEGIN(0);
    }   
}



%% 

void reset(){
    cout << msg << endl; 
    tab = *(new stack<int>);
}

int yywrap(){
  return 1;
}

int main(){
  yylex();
  return 0;
}