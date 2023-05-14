CC=gcc
CFLAGS=-Wall -Wextra -g

all: parser

parser: lex.yy.o y.tab.o hash_table.o
	$(CC) $(CFLAGS) -o parser lex.yy.o y.tab.o hash_table.o
	make run

lex.yy.o: lex.yy.c y.tab.h hash_table.h
	$(CC) $(CFLAGS) -c lex.yy.c

y.tab.o: y.tab.c hash_table.h
	$(CC) $(CFLAGS) -c y.tab.c

hash_table.o: hash_table.c hash_table.h
	$(CC) $(CFLAGS) -c hash_table.c

lex.yy.c: scanner.l
	flex scanner.l

y.tab.c y.tab.h: parser.y
	$(YACC) -d parser.y

clean:
	rm -f parser *.o lex.yy.c y.tab.c y.tab.h

run:
	clear
	./parser
