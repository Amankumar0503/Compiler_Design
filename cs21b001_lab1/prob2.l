%{
#include <stdio.h>
%}

%%
[a-d]+az[a-d]+a|[a-d]+bz[a-d]+b|[a-d]+cz[a-d]+c|[a-d]+dz[a-d]+d         { printf("\n Valid String: %s", yytext); } 
.*                                                                       { printf("\n Invalid String: %s", yytext); }
%%

int main() {
    yylex();
    return 0;
}