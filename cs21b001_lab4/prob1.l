%{
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
%}



%%
[\t]                          /* Ignore whitespace */
\+                        { return '+'; }
\*                        { return '*'; }
[a-zA-Z0-9]+              { return yytext[0];}
\(                        { return '('; }
\)                        { return ')'; }
.                         {}               /* Ignore other characters */

%%

bool E();
bool E_alpha();
bool T();
bool T_alpha();
bool F();

bool E() {
    return T() && E_alpha();
}

bool E_alpha() {
    if (yytext[0] == '+') {
        yylex(); 
        return T() && E_alpha();
    }
    return true;
}

bool T() {
    return F() && T_alpha();
}

bool T_alpha() {
    if (yytext[0] == '*') {
        yylex();
        return F() && T_alpha();
    }
    return true;
}

bool F() {
    if (yytext[0] >= 'a' && yytext[0] <= 'z') {
        yylex();    
        return true;
    }
    else if (yytext[0] >= 'A' && yytext[0] <= 'Z') {
        yylex();    
        return true;
    }
    else if (yytext[0] >= '0' && yytext[0] <= '9') {
        yylex();    
        return true;
    }
    else if((int)yytext[0] == 40 ){
        yylex();
        bool valid = E();
        if((int)yytext[0] == 41){
            yylex();
            return valid;
        }
    }
    return false;
}

int main(int argc, char *argv[]) {
    if (argc!=2){
printf("Usage: %s <input_file>\n", argv[0]);
return 1;
}
    FILE* fp = fopen(argv[1], "r");
    if (fp == NULL) {
        printf("Error opening input file.\n");
    return 1;
    }

    yyin = fp;

    char line[256]; 
    int line_number = 1;    

    while (fgets(line, sizeof(line), fp) != NULL) {
        if (line[strlen(line) - 1] == '\n') {
            line[strlen(line) - 1] = '\0';
        }

        yy_scan_string(line);   
        yylex();    

        if (E()) {
            printf("yes\n");
        } else {
            printf("no\n");
        }

        line_number++;
    }

    return 0;
}