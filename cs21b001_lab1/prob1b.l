%{
int x_count = 0;
int y_count = 0;
int x_mod2 = 0;
int y_mod3 = 0;
int i=0;
int x=1;
%}

%%

.* {
  for(i=0;i<yyleng;i++){
    if(yytext[i]!='x'&& yytext[i]!='y'){
      x--;
      break;
    }
    if(yytext[i]=='x')
    x_count++;
    if(yytext[i]=='y'){
      y_count++;
    }
  }
    x_mod2 = x_count % 2;
    y_mod3 = y_count % 3;
  if(x=1){
  if (x_mod2 == y_mod3) {
    printf("\n Accepted %s", yytext);
  } else {
    printf("\n Rejected %s", yytext);
  }
  }
  else{
    printf("\n Rejected %s", yytext);
  }
}
%%
int main()
{
	 yylex();
	 return 0;
}