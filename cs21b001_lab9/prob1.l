%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
%}

%%
"+"     { return ADD; }
"-"     { return SUB; }
"*"     { return MUL; }
"/"     { return DIV; }
"if"    { return IF;}
"else"  { return ELSE;}
"while" { return WHILE;}
";"     { return SEMICOLON; }
"++"    {return PADD;}
"--"    { return PSUB;}
"="     { return EQ; }
"<"     { return LT; }
"<="    { return LTE;}
">"     { return GT; }
">="    { return GTE; }
"&&"    { return AND; }
"||"    { return OR; }
"!"     { return NOT; }
[0-9]+("."[0-9]+)? { yylval.dval = atoi(yytext); return NUMBER; }
"\("    { return LPAREN; }
"\)"    { return RPAREN; }
"{"     { return LCURL; }
"}"     { return RCURL; }
[a-zA-Z][a-zA-Z0-9]*   { strcpy(yylval.lexeme, yytext) ; return IDENTIFIER; }
[ \t\n]+     {};     
.           {return yytext[0];}; 
<<EOF>>     { return 0; }

%%