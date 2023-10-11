%{

%}
DIGIT [0-9]
LETTER [a-z|A-Z]
LNUMB [{LETTER}|{DIGIT}]
SCHEME ("https"|"http"|"ftp"|"mailto"|"file")
DOMAIN  {LETTER}{LNUMB}*
WEBSITE {LNUMB}+\.{DOMAIN}\.{LETTER}+
QUERYPARAM (\?({DOMAIN}\={DOMAIN}\&{DOMAIN}\={DOMAIN}))
PORT {DIGIT}+
PATH  ({DOMAIN}\/)
WEB_LINK    \/{PATH}+{DOMAIN}\.{LETTER}+
PORT_LINK   \:{PORT}\/{PATH}+{DOMAIN}{QUERYPARAM}
PATH_LINK   \/{PATH}+{DOMAIN}\.{LETTER}+

%%
{SCHEME}\:(\/\/(({WEBSITE}({WEB_LINK}|{PORT_LINK}))|{PATH_LINK})|({DOMAIN}\@{DOMAIN}\.{LETTER}+)) {printf("valid %s\n", yytext);}
.*                             {printf("Invalid %s\n", yytext);}
%%

int main()
{
    yylex();
    return 0;
}