%{
#include <bits/stdc++.h>
#include "identifier.h"
int wordCount = 0;
int lineCount = 1;
int charCount = 0;
int column = 0;
bool comment_multi();
bool comment_line();
void handle(std::string s="");
void lexicalError(std::string);
%}

digit               [0-9]
letter              [a-zA-Z_]
hexdigit            [a-fA-F0-9]
exponent            ([Ee][+-]?{digit}+)
power               ([Pp][+-]?{digit}+)
delimiter           [ \t\r\v\f]
newline             \n
whitespace          {delimiter}+
intsymbol           ((u|U)|(u|U)?(l|L|ll|LL)|(l|L|ll|LL)(u|U))
floatsymbol         (f|F|l|L)

%%
<<EOF>>            { return 0; }

{newline}          { ++lineCount; ++charCount ;column = 0 ; }
"/*"               { if( comment_multi() ) return ERROR; return (COMMENT); }
"//"(\\\n|[^\n])*  { comment_line(); return (COMMENT); }
"auto"             { handle("Reserved word"); return(AUTO); }
"break"            { handle("Reserved word"); return(BREAK); }
"case"             { handle("Reserved word"); return(CASE); }
"char"             { handle("Reserved word"); return(CHAR); }
"const"            { handle("Reserved word"); return(CONST); }
"continue"         { handle("Reserved word"); return(CONTINUE); }
"default"          { handle("Reserved word"); return(DEFAULT); }
"do"               { handle("Reserved word"); return(DO); }
"double"           { handle("Reserved word"); return(DOUBLE); }
"else"             { handle("Reserved word"); return(ELSE); }
"enum"             { handle("Reserved word"); return(ENUM); }
"extern"           { handle("Reserved word"); return(EXTERN); }
"float"            { handle("Reserved word"); return(FLOAT); }
"for"              { handle("Reserved word"); return(FOR); }
"goto"             { handle("Reserved word"); return(GOTO); }
"if"               { handle("Reserved word"); return(IF); }
"inline"           { handle("Reserved word"); return(INLINE); }
"int"              { handle("Reserved word"); return(INT); }
"long"             { handle("Reserved word"); return(LONG); }
"register"         { handle("Reserved word"); return(REGISTER); }
"restrict"         { handle("Reserved word"); return(RESTRICT); }
"return"           { handle("Reserved word"); return(RETURN); }
"short"            { handle("Reserved word"); return(SHORT); }
"signed"           { handle("Reserved word"); return(SIGNED); }
"sizeof"           { handle("Reserved word"); return(SIZEOF); }
"static"           { handle("Reserved word"); return(STATIC); }
"struct"           { handle("Reserved word"); return(STRUCT); }
"switch"           { handle("Reserved word"); return(SWITCH); }
"typedef"          { handle("Reserved word"); return(TYPEDEF); }
"union"            { handle("Reserved word"); return(UNION); }
"unsigned"         { handle("Reserved word"); return(UNSIGNED); }
"void"             { handle("Reserved word"); return(VOID); }
"volatile"         { handle("Reserved word"); return(VOLATILE); }
"while"            { handle("Reserved word"); return(WHILE); }

0|([1-9]{digit}*{intsymbol}?)     { handle("Decimal integer"); return(CONSTANT); }
0[bB][01]+{intsymbol}         { handle("Binary integer"); return(CONSTANT); }
0[xX]{hexdigit}+{intsymbol}?  { handle("Hexadecimal integer"); return(CONSTANT); }
0[0-7]*{intsymbol}?           { handle("Octonary integer"); return(CONSTANT); }


{digit}+{exponent}{floatsymbol}?                     { handle("Decimal float"); return(CONSTANT); }
{digit}*"."{digit}+{exponent}?{floatsymbol}?         { handle("Decimal float"); return(CONSTANT); }
{digit}+"."{digit}*{exponent}?{floatsymbol}?         { handle("Decimal float"); return(CONSTANT); }
0[xX]{hexdigit}+{power}{floatsymbol}?                { handle("Hexadecimal float"); return(CONSTANT); }
0[xX]{hexdigit}*"."{hexdigit}+{power}{floatsymbol}?  { handle("Hexadecimal float"); return(CONSTANT); }
0[xX]{hexdigit}+"."{hexdigit}*{power}{floatsymbol}?  { handle("Hexadecimal float"); return(CONSTANT); }

L?\'(\\\n|[^\'\n])+\'  { handle("Character"); return(CONSTANT); }
L?\'(\\\n|[^\'\n])+    { charCount += yyleng; lexicalError("Unterminated character"); return (PASS); }

L?\"(\\\n|[^\"\n])*\"  { handle("String"); return(STRING_LITERAL); }
L?\"(\\\n|[^\"\n])*    { charCount += yyleng; lexicalError("Unterminated string"); return (PASS); }

{letter}({letter}|{digit})*  { handle("Identifier"); return(VARIANT); }
{digit}({letter}|{digit})+   { charCount += yyleng; lexicalError("Bad identifier format"); return (PASS); }

"..."         { handle("Operator"); return(ELLIPSIS); }
">>="         { handle("Operator"); return(RIGHT_ASSIGN); }
"<<="         { handle("Operator"); return(LEFT_ASSIGN); }
"+="          { handle("Operator"); return(ADD_ASSIGN); }
"-="          { handle("Operator"); return(SUB_ASSIGN); }
"*="          { handle("Operator"); return(MUL_ASSIGN); }
"/="          { handle("Operator"); return(DIV_ASSIGN); }
"%="          { handle("Operator"); return(MOD_ASSIGN); }
"&="          { handle("Operator"); return(AND_ASSIGN); }
"^="          { handle("Operator"); return(XOR_ASSIGN); }
"|="          { handle("Operator"); return(OR_ASSIGN); }
">>"          { handle("Operator"); return(RIGHT_OP); }
"<<"          { handle("Operator"); return(LEFT_OP); }
"++"          { handle("Operator"); return(INC_OP); }
"--"          { handle("Operator"); return(DEC_OP); }
"->"          { handle("Operator"); return(PTR_OP); }
"&&"          { handle("Operator"); return(AND_OP); }
"||"          { handle("Operator"); return(OR_OP); }
"<="          { handle("Operator"); return(LE_OP); }
">="          { handle("Operator"); return(GE_OP); }
"=="          { handle("Operator"); return(EQ_OP); }
"!="          { handle("Operator"); return(NE_OP); }
";"           { handle("Operator"); return(';'); }
("{"|"<%")    { handle("Operator"); return('{'); }
("}"|"%>")    { handle("Operator"); return('}'); }
","           { handle("Operator"); return(','); }
":"           { handle("Operator"); return(':'); }
"="           { handle("Operator"); return('='); }
"("           { handle("Operator"); return('('); }
")"           { handle("Operator"); return(')'); }
("["|"<:")    { handle("Operator"); return('['); }
("]"|":>")    { handle("Operator"); return(']'); }
"."           { handle("Operator"); return('.'); }
"&"           { handle("Operator"); return('&'); }
"!"           { handle("Operator"); return('!'); }
"~"           { handle("Operator"); return('~'); }
"-"           { handle("Operator"); return('-'); }
"+"           { handle("Operator"); return('+'); }
"*"           { handle("Operator"); return('*'); }
"/"           { handle("Operator"); return('/'); }
"%"           { handle("Operator"); return('%'); }
"<"           { handle("Operator"); return('<'); }
">"           { handle("Operator"); return('>'); }
"^"           { handle("Operator"); return('^'); }
"|"           { handle("Operator"); return('|'); }
"?"           { handle("Operator"); return('?'); }

{whitespace}   { charCount += yyleng; column += yyleng; }

. { lexicalError("Unknown symbol"); return (PASS); }


%%

int yywrap(){
    return 1;
}

void lexicalError(std::string errorif){
    fprintf(stderr, "Error: %s, in line %d, column %d:\n%s\n\n", errorif.c_str(), lineCount, column, yytext);
}

bool comment_multi(){
  int st_lino = lineCount, st_cono = column;
  fprintf(stdout, "Multi-line comment at line: %d, column: %d\n", lineCount, column);
  char c, pre = 0;
  fprintf(stdout, "/*");
  charCount += 2;
  while ( (c = yyinput()) != 0 ){
    fprintf(stdout, "%c", c);
    ++charCount;
    if (c == '/' && pre == '*'){
      fprintf(stdout, "\n\n");
      return 0;
    }
    else if( c=='\n' ){
        ++lineCount;
    }
    pre = c;
  }
  fprintf(stderr, "\nUnterminated comment starting at line: %d, column: %d\n\n", st_lino, st_cono);
  return ERROR;
}

bool comment_line(){
     fprintf(stdout, "Line comment at line %d:\n %s\n\n", lineCount, yytext);
     lineCount += std::count(yytext, yytext + yyleng, '\n');
     charCount += yyleng;
     return 0;
}

void handle(std::string s){
    fprintf(stdout, "%s at line %d, column %d:\n%s\n\n", s.c_str(), lineCount, column, yytext);
    if( s == "Identifier" || s == "Reserved word" || s == "Character" || s == "String" ){
        wordCount += 1;
    }
    lineCount += std::count(yytext, yytext + yyleng, '\n');
    charCount += yyleng;
    for (int i = 0; yytext[i] != '\0'; i++){
        if (yytext[i] == '\t'){
            column += 4 - (column % 4);
        }
        else{
            ++column;
        }
    }
}

int main(){
    int res, cnt=0;
    while( (res=yylex())>0 ) ;
    fprintf(stdout, "\n# The number of lines = %d, of words = %d, of chars = %d ", lineCount-1, wordCount, charCount);
    return 0;
}
