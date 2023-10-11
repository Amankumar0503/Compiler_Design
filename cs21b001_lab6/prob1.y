%{
#include<stdio.h>
int yylex();
int yyerror(char *);
int eflag=0;
extern FILE * yyin;
%}
  
%token Num Add Sub Col Id Mul Div OP CL Inc Dec Asg

%%

list:  stmt Col {printf("VALID\n");} list
    |  error Col { printf("INVALID\n"); } list
    | {printf("\n\nCompleted..!\n");} ;
    ;
stmt: Id Asg EXPR
    ;


EXPR:   EXPR Add TERM
    |   EXPR Sub TERM
    |   TERM
    ;

TERM:   TERM Mul FACT
    |   TERM Div FACT
    |   FACT
    ;

FACT: Sub FACT
    | Inc Id
    | Id Inc
    | Id Dec
    | Dec Id
    | OP EXPR CL
    | Id
    | Num
    ;

%%


int yyerror(char *s){
    return 0;
}

int main(int argc, char* argv[])
{
	if(argc > 1)
	{
		FILE *fp = fopen(argv[1], "r");
		if(fp)
			yyin = fp;
	}
	yyparse();
	return 0;
}