NAWL: lex.yy.c
	gcc -o NAWL lex.yy.c -lfl
	rm lex.yy.c

lex.yy.c: NAWL.l
	flex NAWL.l
