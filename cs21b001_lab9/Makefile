CFLAGS=-w
CC=gcc

all:parser

parser: y.tab.c lex.yy.c y.tab.h
	$(CC) $(CFLAGS) y.tab.c lex.yy.c  -o parser

lex.yy.c: prob1.l
	lex prob1.l

y.tab.c: prob1.y
	yacc -v -d -t prob1.y

clean: 
	rm -f parser y.tab.c lex.yy.c y.tab.h y.output