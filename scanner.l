/* Compiler Theory and Design
   Duane J. Jarc */

/* This file contains flex input file */

%{
#include <string>

using namespace std;

#include "types.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		    [ \t\r]+
comment		\-\-.*\n
comment2    \/\/.*\n
line		[\n]
id		    [A-Za-z][A-Za-z0-9]*
exp          (\*\*)
arrow       (=>)
digit		[0-9]
real        [0-9]+([\.][0-9]?)?([eE][-+]?[0-9]+)?
int		    {digit}+
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{comment2}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"<"		    { ECHO; return(RELOP); }
">"         { ECHO; return(RELOP); }
"/="        { ECHO; return(RELOP); }
"<="        { ECHO; return(RELOP); }
">="        { ECHO; return(RELOP); }
"+"		    { ECHO; return(ADDOP); }
"-"		    { ECHO; return(ADDOP); }
"*"		    { ECHO; return(MULOP); }
"/"		    { ECHO; return(MULOP); }
"="		    { ECHO; return(RELOP); }
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
true        { ECHO; yylval.type = BOOL_TYPE;return(BOOL_LITERAL);}
false       { ECHO; yylval.type = BOOL_TYPE;return(BOOL_LITERAL);}
rem         { ECHO; return(REMOP);}
or          { ECHO; return(OROP);}
not         { ECHO; return(NOTOP);}
end		    { ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return(REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; return(ANDOP); }
case        { ECHO; return(CASE); }
else        { ECHO; return(ELSE); }
endcase     { ECHO; return(ENDCASE); }
endif       { ECHO; return(ENDIF); }
if          { ECHO; return(IF); }
others      { ECHO; return(OTHERS); }
real        { ECHO; return(REAL); }
then        { ECHO; return(THEN); }
when        { ECHO; return(WHEN); }
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.type = INT_TYPE; return(INT_LITERAL); }
{real}      { ECHO; yylval.type = REAL_TYPE; return(REAL_LITERAL);}
{exp}       { ECHO; return(EXPOP);}
{arrow}		{ ECHO; return(ARROW);}
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }


%%
