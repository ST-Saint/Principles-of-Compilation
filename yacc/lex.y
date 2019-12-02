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

E : E '+' T { $$ = $1 + $3;} // cout << "reduce E -> E + T"  << endl ; $$ = $1 + $3; cout << YYNTOKENS << endl ; }
| E '-' T { $$ = $1 - $3;} // cout << "reduce E -> E - T" << endl ; $$ = $1 - $3 ;  cout << "E = E - T = " << $$ << endl ;}
| T       { $$ = $1;} // cout << "reduce E -> T" << endl ; $$ = $1 ;  cout << "E = T = " << $$ << endl ;}
  ;

T : T '*' F {$$ = $1 * $3;} // cout << "reduce T -> T * F" << endl ; $$ = $1 * $3 ;  cout << "T = T * F = " << $$ << endl ;}
| T '/' F { $$ = $1 / $3;} // cout << "reduce T -> T / F" << endl ; $$ = $1 / $3 ;  cout << "T = T / F = " << $$ << endl ;}
| F       { $$ = $1;} // cout << "reduce T -> F" << endl ; $$ = $1 ;  cout << "T = F = " << $$ << endl ;}
  ;

F : '(' E ')' { $$ = $2;} // cout << "reduce F -> (E)" << endl ; $$ = $2 ;  cout << "F = (E) = " << $$ << endl ;}
| CONSTANT { $$ = $1;} // cout << "reduce F -> num" << endl ; $$ = $1;  cout << "F = " <<$$ << endl ;}
  ;

%%

int main() {
  yydebug = 1;
  return yyparse();
}
