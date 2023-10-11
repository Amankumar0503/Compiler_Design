%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #define MAX 1000

    struct Symbol {
    char lexeme[MAX];
    char tokenType[MAX];
    };

    struct Symbol symbolTable[1000];
    int symbolCount = 0;

    void AddToTable(const char *lexeme, const char *tokenType) {
        strcpy(symbolTable[symbolCount].lexeme, lexeme);
        strcpy(symbolTable[symbolCount].tokenType, tokenType);
        symbolCount++;
    }

    void printTableToFile() {
        FILE *file = fopen("symbol_table.txt", "w");
        if (file == NULL) {
            fprintf(stderr, "Error opening file for writing symbol table.\n");
            exit(1);
        }

        fprintf(file, "Lexeme\tToken Type\n");
        for (int i = 0; i < symbolCount; i++) {
            fprintf(file, "%s\t%s\n", symbolTable[i].lexeme, symbolTable[i].tokenType);
        }

        fclose(file);
    }


%}


%%
"//".*  { /* Ignore single-line comments */ }
"/\\*[^*]*\\*+(?:[^/*][^*]*\\*+)*/" { /* Ignore Double-line comments */ }
[ \t\n]+ { /* Ignore whitespace and newline */ }
auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while|bool { AddToTable(yytext, "Keyword"); }
[0-9]+          { AddToTable(yytext, "Integer Constant"); }
[0-9]+"."[0-9]+ { AddToTable(yytext, "Floating Point Constant"); }
\"[^\"\n]*\"    { AddToTable(yytext, "String Constant"); }
\'[^\'\n]\'     { AddToTable(yytext, "Character Constant"); }
[a-zA-Z_][a-zA-Z0-9_]* { AddToTable(yytext, "Identifier"); }
[+\-*/=<>!%]  { AddToTable(yytext, "Operator"); }
[\(\)\[\]\{\}\;\,] { AddToTable(yytext, "Punctuation"); }


%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *inputFile = fopen(argv[1], "r");
    if (inputFile == NULL) {
        fprintf(stderr, "Error opening input file.\n");
        return 1;
    }

    yyin = inputFile;
    yylex();

    fclose(inputFile);

    printTableToFile();

    return 0;
}
