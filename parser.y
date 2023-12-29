%{
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
extern FILE * yyin;
void yyerror(char *);
int sym[1000];
%}
%token IF ELSE NUMBER PLUS MINUS SEMI PR PL THEN EQUAL EXIT MULT DIV POW CAT VARIABLE FOR DOLLAR
%left ELSE
%left FOR
%left EQUAL
%left PLUS MINUS
%left MULT DIV
%left IF
%right POW
%%
program:
		program line
		|;
line:   
		Exp
		|ifELse line
		|forLoop line
		|VARIABLE '=' Exp  SEMI { sym[$1] = $3;}
		|CAT Exp SEMI  {printf(" %d\n",$2);}
		|EXIT {printf("Bye bye");exit(0);}
		;
ifELse:	IF PR Condition PL THEN '{' Statment  '}' ELSE '{' Statment '}' SEMI {
														if($3){
															printf("In the if true part\n");															
															printf(" %d\n",$7);
															}
														else{
															printf("In the else part\n");
															printf(" %d\n",$11);
															}
															printf("\n");
														}
		| IF PR Condition PL THEN '{' Statment '}' SEMI{
											if($3){
													printf(" In the if true part %d",$7);
													}
											else
												printf("incorrect condition");	
											
											printf("\n");
											}
		;
forLoop: FOR PR NUMBER SEMI Condition SEMI NUMBER PL THEN '{' Statment  '}' DOLLAR {
	int i;
    int start = $3;
    int end = $7;
    for ( i = start; i < end; i++) {
        if ($5) {
            printf("loop condition met ");
            printf(" %d", i);
            printf(" Body : %d\n", $11);
        } else {
            printf("loop condition not met\n");
			break;
        }
    }
}
;

Condition:	Exp '>' Exp {$$ =  $1 > $3? 1: 0 ;}
			| Exp '<' Exp {$$ =  $1 < $3? 1: 0; }
			| Exp EQUAL Exp {$$ = $1 == $3? 1: 0 ; }
			| Exp MINUS Exp {$$ =  $1 - $3>0? 1: 0 ;}
			| Exp PLUS Exp {$$ =  $1 + $3>0? 1: 0; }
			| NUMBER
			|VARIABLE { $$ = sym[$1];}
			
			;
Statment:	
		 line
			;
Exp:		NUMBER
			| VARIABLE  { $$ = sym[$1];}
			| Exp PLUS Exp {$$ = $1 + $3;}
			| Exp MINUS Exp {$$ = $1 - $3;}
			| Exp MULT Exp {$$ = $1 * $3;}
			| Exp DIV Exp {
						if($3 == 0){
							printf("Can not divide by zero\n");
							}
						else
							$$ = $1 / $3;}
			| Exp POW Exp {
						int x = $1;
						for(int i = 1;i<$3;i++)
							x *=$1;
						$$ = x;
						}
			
			;
%%
void yyerror(char *s) {
printf("Error: %s\r\n", s);
}
int main(void){
	yyin = fopen( "input.txt", "r" );
	yyparse();
	
	fclose(yyin);

	return 0;
	}