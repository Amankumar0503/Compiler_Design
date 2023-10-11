%{
#include<stdio.h>
int yylex();
int yyerror(char *);
int eflag=0;
extern FILE * yyin;
%}
  
%token Int Iota Add Sub Subcol

%%

slist : 	COMPLEX Subcol {printf("VALID\n");} slist
            |  error { printf("INVALID\n"); } Subcol slist
            | {printf("\n\nCompleted..!\n");} ;
      ;

COMPLEX : Img 
    | Real Add Img 
    | Real Sub Img  ;

Real: Int ; 

Img : Real Iota 
    | Iota 
    | Iota Real ;
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
