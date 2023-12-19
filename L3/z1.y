%{
#include <iostream>
#include <string>
#define pZ 1234577

using namespace std; 

extern int yylex();
extern int yyparse();
int yyerror(string s);

int add(long a, long b, long p);
int sub(long a, long b, long p);
int inv(int a, long p);
int mul(long a, long b, long p);
int pow(long a, int b, long p);
int un(long a, long p);

int var;

string error = "";
string rpn = "";
%}

%token '\n'
%token NUM
%token ERR
%left '+' '-'
%left '*' '/'
%precedence NEG
%nonassoc '^'
%token '('
%token ')'

%%

input:
    /* empty */
    | input line
;
line: 
    expr '\n' { 
            cout << "RPN: " << rpn << endl;
            cout << "= " << $1 << endl; 
            rpn = "";
        }
    | error '\n' { 
            cout << "Błąd: " << error << endl; 
            rpn = ""; 
            error = "";
        }
;
expr: 
    number                          { rpn += to_string($1) + " "; $$ = $1; }
    | '(' expr ')'                  { $$ = $2; }
    | '-' '(' expr ')' %prec NEG    { rpn += "~ "; $$ = ((-$3 % pZ) + pZ) % pZ; }
    | expr '+' expr                 { rpn += "+ "; $$ = add($1, $3, pZ); }
    | expr '-' expr                 { rpn += "- "; $$ = sub($1, $3, pZ); }
    | expr '*' expr                 { rpn += "* "; $$ = mul($1, $3, pZ); }
    | expr '^' expo               { rpn += "^ "; $$ = pow($1, ($3 + pZ) % pZ, pZ); }
    | expr '/' expr { 
            rpn += "/ "; 
            if ($3 == 0) { 
                error = "dzielenie przez 0"; 
                YYERROR; 
            } 
            else
                $$ = mul($1, inv($3, pZ), pZ); 
        }
;
number:
    NUM                     { $$ = $1; }
    | '-' number %prec NEG  { $$ = ((-$2 % pZ) + pZ) % pZ; }
;





exponumber:
    NUM                     { $$ = ($1 % (pZ-1)); }
    | '-' exponumber %prec NEG  {  $$ = ((-$2 % (pZ-1)) + pZ-1) % (pZ-1); }
;

expo: 
    exponumber                          { rpn += to_string($1) + " "; $$ = $1; }
    | '(' expo ')'                  { $$ = $2; }
    | '-' '(' expo ')' %prec NEG    { rpn += "~ "; $$ = ((-$3 % (pZ-1)) + pZ-1) % (pZ-1); }
    | expo '+' expo                 { rpn += "+ "; $$ = add($1, $3, pZ-1); }
    | expo '-' expo                 { rpn += "- "; $$ = sub($1, $3, pZ-1); }
    | expo '*' expo                 { rpn += "* "; $$ = mul($1, $3, pZ-1); }
    | expo '/' expo {  
            rpn += "/ "; 
            if ($3 == 0) { 
                error = "dzielenie przez 0"; 
                YYERROR; 
            } 
            else {
              var = mul($1, $3, pZ-1); 
              if(error != "") {
                $$ = var; 
              }
              else {
                error = to_string($3) + " nie jest odwracalne modulo " + to_string(pZ-1);
                YYERROR; 
              }
            }
        }
;

%%

int add(long a, long b, long p){
  long x = (a+b)%p;
  return x;
}

int sub(long a, long b, long p){
  long x = (a-b)%p;
  if(x < 0) x+= p;
  return x;
}

int inv(int a, long p){
  int u = 1;
  int w = a;
  int x = 0; 
  int z = p;
  int q;
  int var;

  while(w != 0){
    if(w<z){
      var = u;
      u = x;
      x = var;

      var = w;
      w = z;
      z = var;
    }

    q = w/z;
    u -= q*x;
    w -= q*z;
  }

  return (x+p)%p;
}

int mul(long a, long b, long p){
  long x = (a*b)%p;
  return x;
}

int pow(long a, int power, long p) {
    if (power == 0){return 1;}    
    long b = pow(a, power/2, p);
    if(power % 2 == 0){
      return (b*b) % p;
      }
    else{
      return (a*b*b) % p;
    }  
}

int un(int a, long p){
  if(a < 0){
    return (p-a)%p;
  }
  else{
    return a%p;
  }
}

int yyerror(string s) {	
    return 1;
}

int main(){
    yyparse();
    return 0;
}