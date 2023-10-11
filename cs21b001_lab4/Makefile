CFLAGS=-g -DDEBUG 
CC=gcc
Parser: lex.yy.c 
	$(CC) lex.yy.c -ll -o Parser

lex.yy.c:prob1.l
	flex prob1.l

clean: 
	rm -f *.o lex.yy.c Parser 
