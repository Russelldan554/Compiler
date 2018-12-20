/* Compiler Theory and Design
   Duane J. Jarc */

%{

#include <string>
#include <vector>
#include <map>

using namespace std;

#include "types.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<Types> symbols;
Symbols<double> valSymbols;

double* params = NULL;
int count = 1;
bool found = false;
bool others = false;
bool caseSet = false;
Types caseType = MISMATCH;



%}

%error-verbose

%union
{
	CharPtr iden;
	Operators oper;
	Vals vals;
	Types type;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL
%token <type> BOOL_LITERAL
%token <type> REAL_LITERAL

%token <oper> ADDOP MULOP RELOP ANDOP
%token <oper> REMOP OROP NOTOP EXPOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS

%token REAL ARROW  THEN WHEN IF ELSE OTHERS ENDIF CASE ENDCASE

%type <vals> type statement statement_ reductions expression relation term
	factor primary case switch exponent word phrase function_header body

%type <oper> operator multiple


%%

function:	
	function_header optional_variable body  ;
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';'   |
	error ';' ;

parameters:
    parameter |
    parameter ',' parameters |
    %empty ;

parameter:
    IDENTIFIER ':' type  ;

optional_variable:
    %empty |
	optional_variable variable ;

variable:	
	IDENTIFIER ':' type IS statement_ ;

type:
	INTEGER   |
	BOOLEAN  |
	REAL ;

body:
	BEGIN_ statement_ END ';'  ;
    
statement_:
	statement ';' |
	error ';'  ;
	
statement:
	expression  |
	REDUCE operator reductions ENDREDUCE  |
	IF expression THEN statement_ ELSE statement_ ENDIF |
    CASE expression IS case OTHERS ARROW statement ';' ENDCASE  ;

case:
    case switch |
    %empty  ;

switch:
    WHEN INT_LITERAL ARROW statement_   ;

operator:
	ADDOP |
	multiple ;

multiple:
    MULOP ;

reductions:
	reductions statement_  |
	%empty ;
		    
expression:
	expression OROP phrase  |
	phrase ;

phrase:
    phrase ANDOP relation  |
    relation;

relation:
	relation RELOP term |
	term ;

term:
	term ADDOP factor |
	factor ;
      
factor:
	factor MULOP exponent   |
	factor REMOP exponent  |
	exponent ;

exponent:
    word EXPOP exponent  |
    word ;

word:
    NOTOP primary  |
    primary ;

primary:
	'(' expression ')'  |
	INT_LITERAL |
	REAL_LITERAL |
    BOOL_LITERAL |
	IDENTIFIER  ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
    params= new double[argc];

        if (argc > 0) {
            for (int i = 1; i < argc; i++) {
                params[i] = atof(argv[i]);
            }
        }

	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
