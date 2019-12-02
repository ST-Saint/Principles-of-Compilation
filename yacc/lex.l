%{
#include <bits/stdc++.h>
#include "y.tab.hh"
extern "C"{
int yywrap(void);
int yylex(void);
}
using namespace std;
%}

digit                           [0-9]
exponent                        ([Ee][+-]?{digit}+)

%%

[-/+*()]                        { yylval.char_value = yytext[0];     return yytext[0]; }
0|([1-9]{digit}*?)              { yylval.double_value = atoi(yytext); return CONSTANT; }
{digit}+{exponent}?             { yylval.double_value = atof(yytext); return CONSTANT; }
{digit}*"."{digit}+{exponent}?  { yylval.double_value = atof(yytext); return CONSTANT; }
{digit}+"."{digit}*{exponent}?? { yylval.double_value = atof(yytext); return CONSTANT; }

%%

int yywrap(void) {
  return 1;
}
