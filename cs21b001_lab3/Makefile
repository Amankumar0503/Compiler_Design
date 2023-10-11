CFLAGS=-g -DDEBUG 
CC=gcc
lexer: lex.yy.c 
	$(CC) lex.yy.c -ll -o lexer

lex.yy.c:prob1.l
	flex prob1.l

clean: 
	rm -f *.o lex.yy.c lexer symbol_table.txt
