%{
	 // c declarations 
     void print(char*, char*);
%}


%%
(10|1)*111(10|1)*   { print("\n Valid :",yytext); }
(01|1)*111(01|1)*   { print("\n Valid :",yytext); }
(10|1)*111(01|1)*   { print("\n Valid :",yytext); }
(01|1)*111(10|1)*   { print("\n Valid :",yytext); }
.*					{ print("\n Invalid :",yytext); }

%%

int main()
{
	 yylex();
	 return 0;
}
void print(char* token, char* lexeme){
	printf("\n %s %s", token, lexeme);
}

