%{
#include <stdlib.h>
#include <stdio.h>
#include "parser.tab.h"
#define MAX_SIZE 1000
int num_of_v=0;
struct KeyValue {
    char key[20];
    int value;
};

struct KeyValue myMap[MAX_SIZE]; 

void addToMap(const char *key, int value) {
    for (int i = 0; i < MAX_SIZE; ++i) {
        if (strcmp(myMap[i].key, key) == 0) {
            // Key already exists, update the value
            myMap[i].value = value;
            return;
        }
    }

    // Key not found, add a new entry
    for (int i = 0; i < MAX_SIZE; ++i) {
        if (myMap[i].key[0] == '\0') {
            strcpy(myMap[i].key, key);
            myMap[i].value = value;
            return;
        }
    }

    // Map is full
    printf("Error: Map is full, cannot add more entries.\n");
}

int getValueFromMap(const char *key) {
    for (int i = 0; i < MAX_SIZE; ++i) {
        if (strcmp(myMap[i].key, key) == 0) {
            return myMap[i].value;
        }
    }

    // Key not found
    return -1; // You can choose a different sentinel value or handle it differently
}

%}
Num [0-9]+
Blank [ \t\n]+
Special [><={}]

%%

{Num}	{yylval = atoi(yytext);
		return(NUMBER);
		}
{Special} {return(yytext[0]);}
"+" 	{return(PLUS);}
"-"		{return(MINUS);}
"*"		{return(MULT);}
"/"		{return(DIV);}
"^"		{return(POW);}
";"		{return(SEMI);}
"$"		{return(DOLLAR);}
"("		{return(PR);}
")"		{return(PL);}
"if"	{return(IF);}
"for"	{return(FOR);}
"else"	{return(ELSE);}
"then"	{return(THEN);}
"=="	{return(EQUAL);}
"exit"  {return(EXIT);}
"cat"  {return(CAT);}
{Blank}	{;}
[a-zA-Z][a-zA-Z0-9]* {   
                if(getValueFromMap(yytext)==-1)
                  {
                        addToMap(yytext, num_of_v);
                       yylval = num_of_v;
                        num_of_v++;
                   }
                else
                yylval=getValueFromMap(yytext);
                return VARIABLE; }

.		{yyerror("UnExpected input %c\n",*yytext);}
%%
int yywrap(void) {
    return 0;
}