%x TABLE TABLEHEADER UNORDEREDLIST
%option stack

%{
#include<string.h>
#include<stdio.h>
#include<stdlib.h>

void makeHeader(char* str, int N){	
	for(int i=0;i<N;i++)printf("=");
	printf("%s",str);
	for(int i=0;i<N;i++)printf("=");
	printf("\n");
}

void printTableOptions(char* content){
	printf("{| border=\"0\" cellspacing=\"1\" cellpadding=\"1\" style=\"width:500px;\" class=\"article-table\"\n|-\n! scope=\"col\"|%s",content);
}

%}

%%

h[1-6]\_[a-zA-Z\ 0-9]+\n {
	yytext[yyleng-1]='\0';
	char* str=strdup(yytext+3);
	yytext[2]='\0';
	makeHeader(str,atoi(yytext+1));
}

Table:\_\n[a-zA-Z\ 0-9]+ {
	yy_push_state(TABLE);
	yy_push_state(TABLEHEADER);
	printTableOptions(yytext+8);
}
<TABLEHEADER>\|\|[a-zA-Z0-9\ ]+ {
	printf("\n! scope=\"col\"|%s",yytext+2);
}
<TABLEHEADER>\n[a-zA-Z0-9\ ]+ {
	printf("\n|-\n|%s",yytext+1);
	yy_pop_state();
}

<TABLE>\|\|[a-zA-Z0-9\ ]+ {
	printf("\n|%s",yytext+2);
}

<TABLE>\n[a-zA-Z0-9\ ]+ {
	printf("\n|-\n|%s",yytext+1);
}

<TABLE>\n_END {
	printf("\n|}");
	yy_pop_state();
}

UL:_ {
	yy_push_state(UNORDEREDLIST);
}
<UNORDEREDLIST>\n printf("\n*");
<UNORDEREDLIST>\n_END {
	yy_pop_state();
}
%%