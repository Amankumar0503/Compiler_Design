%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
%}

INT [0-9]+

/* Rule Section */
%%
{INT}  return Int;
"i" return Iota ;
"+" return Add ;
"-" return Sub;
";" return Subcol;
[ \t\n]+     {};      /* ignore white space */
.           {return yytext[0];}; /* ignore all other characters */

%%

int yywrap()
{
return 1;
}
