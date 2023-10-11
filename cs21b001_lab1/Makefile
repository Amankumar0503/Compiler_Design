CFLAGS=-g -DDEBUG 
CC=gcc


lexer: lex.yy.c 
	$(CC) lex.yy.c -ll -o lexer

lex.yy.c: $(filename)
	flex $(filename)

clean: lex.yy.c lexer
	rm -f lex.yy.c lexer
