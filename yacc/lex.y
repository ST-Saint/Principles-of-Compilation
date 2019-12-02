%{
  #include <bits/stdc++.h>
  #define YYDEBUG 1
  #define eps 1e-5
  extern "C" {
    void yyerror(const char *){};
    extern int yylex(void);
    extern char *yytext;
    extern int yydebug;
  }

  using namespace std;
%}

%union {
  char char_value;
  double double_value;
}

%start E

%token <double_value> CONSTANT
%type <double_value> E T F

%left <char_value> '+' '-' '*' '/'
%token <char_value> '(' ')'

%printer {
  int r = round($$);
  if( abs(r-$$)<=eps ){
    fprintf (yyo, "%d", r);
  }
  else{
    fprintf (yyo, "%lf", $$);
  }
 } <double_value>

%printer {
   fprintf (yyo, "'%c'", $$);
} <char_value>

%%

E : E '+' T { $$ = $1 + $3 ;}
  | E '-' T { $$ = $1 - $3 ;}
  | T       { $$ = $1      ;}
  ;

T : T '*' F {$$ = $1 * $3  ;}
  | T '/' F { $$ = $1 / $3 ;}
  | F       { $$ = $1      ;}
  ;

F : '(' E ')' { $$ = $2    ;}
  | CONSTANT  { $$ = $1    ;}
  ;

%%

int main() {
  yydebug = 1;
  return yyparse();
}
