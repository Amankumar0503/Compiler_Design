%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(char*);
int yylex();
extern FILE* yyin;

char str[1000];
char* genLabel();
char* genBlockLabel();
char* genOutLabel();
char* genBeginLabel();
char* OutLabel(int Ocount);
int t = 0;
int l = 0;
int w = 0;
int z = 0 ; 
int count = 1;
// stack for storing the labels
char* stack[1000] ;
int Ocount = 0;
%}

%start StatementList

%token IF ELSE ADD SUB MUL DIV EQ LT LTE GT GTE NOT AND OR PADD PSUB LPAREN RPAREN LCURL RCURL SEMICOLON WHILE COLON SWITCH BREAK CONTINUE DEFAULT CASE 

%nonassoc LT GT LTE GTE NOT EQ AND OR
%left ADD SUB
%left MUL DIV
%right LPAREN LCURL
%right RPAREN RCURL
%nonassoc PADD PSUB

%union {
    char lexeme[100];
    char addr[200];
    char addCase[200];
    char* lab;
    int dval;
}

%token <dval> NUMBER
%token <addr> IDENTIFIER
%type <addr> StatementList
%type <addr> IfStatement
%type <addr> SwitchStatement 
%type <addr> ElseStmt
%type <addr> ComRelExp
%type <addr> Relexp
%type <addr> Statement
%type <addr> Term
%type <addr> Factor
%type <addr> SIGNVal
%type <addr> Val
%type <addCase> CaseVal
%type <addr> CaseStatements
%type <addr> BreakStmt
%type <lab> dummyLabels
%type <lab> begin

%%

StatementList:
    Statement SEMICOLON StatementList { printf("\n"); }
    | IfStatement StatementList { printf("\n"); }
    | WHILE LPAREN ComRelExp RPAREN LCURL begin dummyLabels { printf("\nif %s goto %s:\ngoto %s:", $3, $6, $7); }
      StatementList RCURL { printf("\ngoto %s:", $6); } { printf("\n%s:", $7); } StatementList { printf("\n"); }
    | SwitchStatement  { printf("\n"); }       
    |{}
    ;

SwitchStatement:
    SWITCH LPAREN CaseVal  {count++; stack[count] = (char*)malloc(sizeof(char) * 1000); strcpy(stack[count], $3); } RPAREN LCURL 
     CaseStatements RCURL  {printf("\n%s:" , genOutLabel()); Ocount++ ;count --; } StatementList { printf("\n"); }
    ;

CaseStatements:
    CASE CaseVal COLON dummyLabels { printf("\nifFalse (%s == %s) goto %s", stack[count], $2, $4);}
     StatementList BreakStmt { printf("\n%s:",$4);} CaseStatements  
    | DEFAULT COLON StatementList { printf("\n"); }
    | {}/* Empty case, no code to generate */
    ;

BreakStmt : 
    BREAK SEMICOLON { printf("goto %s\n", OutLabel(Ocount)); }

IfStatement:
    IF LPAREN ComRelExp RPAREN dummyLabels LCURL { printf("\nifFalse %s goto %s ", $3, $5); }
     StatementList RCURL{ printf("\n%s:", $5); } ElseStmt StatementList { printf("\n"); }
    ;

ElseStmt:
    ELSE LCURL StatementList RCURL {}
    | ELSE IfStatement {}
    | {}
    ;

dummyLabels:
    { $$ = (char*)malloc(100 * sizeof(char)); $$ = genBlockLabel(); }

begin:
    { $$ = (char*)malloc(100 * sizeof(char)); $$ = genBeginLabel(); }


Statement:
    IDENTIFIER EQ Statement {
        strcpy($$, $1);
        strcat($$, "=");
        strcat($$, $3);
        printf("\n%s", $$);
    }
    | Term { strcpy($$, $1); }
    ;

ComRelExp:
    ComRelExp AND Relexp {
        strcpy($$, genLabel());
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, "&&");
        strcat(str, $3);
        printf("\n%s", str);
    }
    | ComRelExp OR Relexp {
        strcpy($$, genLabel());
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, "||");
        strcat(str, $3);
        printf("\n%s", str);
    }
    | Relexp { strcpy($$, $1); }
    ;

Relexp:
    Term LT Term {
        strcpy($$, genLabel());
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, "<");
        strcat(str, $3);
        printf("\n%s", str);
    }
    | Term LTE Term {
        strcpy($$, genLabel());
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, "<=");
        strcat(str, $3);
        printf("\n%s", str);
    }
    | Term GT Term {
        strcpy($$, genLabel());
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, ">");
        strcat(str, $3);
        printf("\n%s", str);
    }
    | Term GTE Term {
        strcpy($$, genLabel());
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, ">=");
        strcat(str, $3);
        printf("\n%s", str);
    }
    | Term EQ EQ Term {
        strcpy($$, genLabel());
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, "==");
        strcat(str, $4);
        printf("\n%s", str);
    }
    | Term NOT EQ Term {
        strcpy($$, genLabel());
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, "!=");
        strcat(str, $4);
        printf("\n%s", str);
    }
    | LPAREN Relexp RPAREN {
        strcpy($$, genLabel());
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, "!");
        strcat(str, "(");
        strcat(str, $2);
        strcat(str, ")");
        printf("\n%s", str);
    }
    | NOT Relexp {
        strcpy($$, genLabel());
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, "!");
        strcat(str, $2);
        printf("\n%s", str);
    }
    | {}
    ;

Term:
    Term ADD Factor {
        strcpy($$, genLabel());
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, "+");
        strcat(str, $3);
        printf("\n%s", str);
    }
    | Term SUB Factor {
        strcpy($$, genLabel());
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, "-");
        strcat(str, $3);
        printf("\n%s", str);
    }
    | Factor { strcpy($$, $1); }
    ;

Factor:
    Factor MUL SIGNVal {
        char* g = genLabel();
        strcpy($$, g);
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, "*");
        strcat(str, $3);
        printf("\n%s", str);
    }
    |Factor DIV SIGNVal {
        char* g = genLabel();
        strcpy($$, g);
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, "/");
        strcat(str, $3);
        printf("\n%s", str);
    }
    | SIGNVal { strcpy($$, $1); }
    ;

SIGNVal:
    ADD Val {
        strcpy($$, "+");
        strcat($$, $2);
    }
    | SUB Val {
        strcpy($$, "-");
        strcat($$, $2);
    }
    | Val { strcpy($$, $1); }
    ;


CaseVal: 
     IDENTIFIER {
        
        strcpy($$, $1);
    }
    | NUMBER {
        char* buf = (char*)malloc(sizeof(char) * 1000);
        int dummyLabels = $1;
        sprintf(buf, "%d", dummyLabels);
        strcpy($$, buf);
    };
    

Val:
    IDENTIFIER {
        strcpy($$, $1);
    }
    | NUMBER {
        char* buf = (char*)malloc(sizeof(char) * 1000);
        int dummyLabels = $1;
        sprintf(buf, "%d", dummyLabels);
        strcpy($$, buf);
    }
    | PADD IDENTIFIER {
        strcpy($$, $2);
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $2);
        strcat(str, "+1");
        printf("\n%s", str);
    }
    | PSUB IDENTIFIER {
        strcpy($$, $2);
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $2);
        strcat(str, "-1");
        printf("\n%s", str);
    }
    | IDENTIFIER PADD {
        strcpy($$, $1);
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, "+1");
        printf("\n%s", str);
    }
    | IDENTIFIER PSUB {
        strcpy($$, $1);
        strcpy(str, $$);
        strcat(str, "=");
        strcat(str, $1);
        strcat(str, "-1");
        printf("\n%s", str);
    }
    | LPAREN Term RPAREN { strcpy($$, $2); }
    ;

%%

void yyerror(char* s) {
    while (yylex() != SEMICOLON && yylex() != EOF);
    printf("Rejected EXPR\n");
    yyparse();
}

char* genLabel() {
    char* s = (char*)malloc(sizeof(char) * 1000);
    char* label = (char*)malloc(sizeof(char) * 1000);
    strcpy(s, "t");
    sprintf(label, "%d", t);
    strcat(s, label);
    t++;
    return s;
}

char* genBlockLabel() {
    char* s = (char*)malloc(sizeof(char) * 1000);
    char* label = (char*)malloc(sizeof(char) * 1000);
    strcpy(s, "L");
/*Out:
    { $$ = (char*)malloc(100 * sizeof(char)); $$ = genOutLabel(); }*/
    sprintf(label, "%d", l);
    strcat(s, label);
    l++;
    return s;
}

char* genBeginLabel() {
    char* s = (char*)malloc(sizeof(char) * 1000);
    char* label = (char*)malloc(sizeof(char) * 1000);
    strcpy(s, "BEGIN");
    sprintf(label, "%d", w);
    strcat(s, label);
    w++;
    return s;
}

char* genOutLabel() {
    char* s = (char*)malloc(sizeof(char) * 1000);
    char* label = (char*)malloc(sizeof(char) * 1000);
    strcpy(s, "OUT");
    sprintf(label, "%d", z);
    strcat(s, label);
    z++;
    return s;
}
char* OutLabel(int Ocount){
    char* s = (char*)malloc(sizeof(char) * 1000);
    char* label = (char*)malloc(sizeof(char) * 1000);
    strcpy(s, "OUT");
    sprintf(label, "%d", Ocount);
    strcat(s, label);
    Ocount++;
    return s;
}


int main(int argc, char* argv[]) {
    if (argc > 1) {
        FILE* fp = fopen(argv[1], "r");
        if (fp) yyin = fp;
    }
    yyparse();
    return 0;
}
