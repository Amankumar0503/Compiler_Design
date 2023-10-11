%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

INT [0-9]+
FLOAT {INT}\.{INT}
ID  [_a-zA-Z][_a-zA-Z0-9]*

/* Rule Section */
%%
{INT}|{FLOAT}  return Num;
{ID}   return Id;
\+ return Add ;
"-" return Sub;
"*" return Mul;
"/" return Div;
";" return Col;
"(" return OP;
")" return CL;
"++" return Inc;
"--" return Dec;
"=" return Asg;
[ \t\n]+     {};      /* ignore white space */
.           {return yytext[0];}; /* ignore all other characters */

%%

int yywrap()
{
return 1;
}