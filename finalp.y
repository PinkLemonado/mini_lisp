%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
char id_la[200][50];
double num[200];
int len=0;
void yyerror(const char *message);
%}
%union {
int ival;
struct QAQ{
	int boo;
	int VAL;
}qaq;
char istr[50];
}
%token <ival> INUMBER
%token <ival> BOOL
%token MOD AND OR NOT
%token PRINT_NUM PRINT_BOOL DEFINE FUN IF
%token <istr> ID
%type <ival> exp plus minus multiply divide modulus
%type<ival> prog stmts def_stmt print_stmt
%type<ival> num_op log_op exp_plus exp_mult greater smaller equal
%type <ival> and_op or_op not_op exp_and exp_or 
%type <ival> if_exp test_exp then_exp else_exp 
%type <qaq> exp_equ
%left '+' '-'
%left '*' '/'
%left '(' ')'
%nonassoc SYMBO
%%
prog		: stmts
		;
stmts	: exp
		|def_stmt
		|print_stmt	{$$=$1; }
		|stmts stmts	
		;
print_stmt	:'(' PRINT_NUM exp ')'	{	
									printf("%d",$3); printf("\n"); 
								}
			|'(' PRINT_BOOL exp ')'	{if($3==1) printf("#t\n"); else printf("#f\n"); }
			;
exp		:BOOL			
		|INUMBER
		|ID				{
							int i=0;
							while(i<len){
								if(strncmp($1, id_la[i], sizeof(id_la[i])) == 0){
									$$=num[i];	
									break;
								}
								else{
									i++;
								}
							}
						}
		|num_op		{$$=$1; }
		|log_op			{$$=$1; }
		|fun_exp
		|fun_call
		|if_exp
		;
num_op	:plus	{$$=$1; }
		|minus	{$$=$1; }
		|multiply	{$$=$1; }
		|divide	{$$=$1; }
		|modulus	{$$=$1; }
		|greater		
		|smaller
		|equal
		;
plus		: '(' '+' exp_plus ')'	{ $$=$3; }
		;
exp_plus	:exp_plus	exp 	{$$=$1+$2; }
		| exp exp		{$$=$1+$2; }
		;
minus	:'(' '-' exp exp ')'	{$$=$3-$4; }
		;
multiply	:'(' '*' exp_mult ')'	{$$=$3; }
		;
exp_mult	:exp_mult	 exp 	{$$=$1*$2; }
		|exp exp		{$$=$1*$2; }
		;
divide	:'(' '/' exp exp ')'	{$$=$3/$4; }
		;
modulus	:'(' MOD exp exp ')'	{$$=$3-($3/$4)*$4; }
		;
greater	:'(' '>' exp exp ')'	{
							if($3>$4) $$=1;
							else $$=0;
						}
		;
smaller	:'(' '<' exp exp ')'	{
						if($3<$4) $$=1;
						else $$=0;
						}
		;
equal	:'(' '=' exp_equ ')'	{$$=$3.boo;}
		;
exp_equ	:exp_equ exp	{
						if($1.boo==0){
							$$.boo=0;
						}
						else{
							if($1.VAL==$2){
								$$.boo=1;
								$$.VAL=$2;
							}
							else{
								$$.boo=0;
							}
						}
					}
		|exp exp		{	
						if($1==$2){
							$$.boo=1;
							$$.VAL=$1;
						}
						else{
							$$.boo=0;
						}
					}
		;
log_op	:and_op
		|or_op
		|not_op
		;
and_op	:'(' AND exp_and ')'	{$$=$3; }
		;
exp_and	:exp_and exp		{$$=$1&&$2; }
		|exp
		;
or_op	:'(' OR exp_or ')'	{$$=$3; }
		;
exp_or	:exp_or exp	{$$=$1||$2; }
		|exp
		;
not_op	:'(' NOT exp ')'	{$$=1-$3; }
		;
def_stmt	:'(' DEFINE ID exp ')'	{	int i=0;
								while(i<len){
									if(strncmp($3, id_la[i], sizeof(id_la[i])) == 0){
										printf("redefining is not allowed.\n");
										break;
									}
									else{
										i++;
									}
								}
								sprintf(id_la[len], "%s", $3);
								num[len]=$4;
								len+=1; 
								
							}
		;
fun_exp	:'(' FUN fun_ids fun_body ')'
		;
fun_ids	:'(' ID ')'
		;
fun_body	:exp
		;
fun_call	:'(' fun_exp param ')'
		|'(' fun_name param ')'
		;
param	:exp
		;
fun_name:ID
		;
if_exp	:'(' IF test_exp then_exp else_exp ')'	{
											if($3) $$=$4;
											else $$=$5;
										}
		;
test_exp	:exp
		;
then_exp	:exp
		;
else_exp	:exp
		;
%%
void yyerror (const char *message)
{
        fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}
