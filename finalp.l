%{
#include "y.tab.h"
%}
%%
[ \t\n\r]+	{ /* do nothing */ }
[-]?[1-9]+[0-9]*|[0-9]+	{ yylval.ival = atoi(yytext);return(INUMBER); }
"/"|"-"|"+"|"*"|"("|")"|">"|"<"|"="	{return(yytext[0]); }
"mod"	{return(MOD); }
"and"	{return(AND); }
"or"		{return(OR); }
"not"	{return(NOT); }
"#t"		{yylval.ival = 1; return(BOOL); }
"#f"		{yylval.ival = 0; return(BOOL); }
"print-num"	{return(PRINT_NUM); }
"print-bool"	{return(PRINT_BOOL); }
"define"		{return(DEFINE); }
"fun"		{return(FUN); }
"if"			{return(IF); }
[a-zA-Z]+[a-zA-Z0-9-]*	{sprintf(yylval.istr, "%s", yytext); return(ID); }
.	{ return(yytext[0]); }
%%

