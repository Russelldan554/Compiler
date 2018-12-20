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
#include "values.h"

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

struct Vals
{
Types type;
double value;
};

%}

%error-verbose

%union
{
	CharPtr iden;
	Operators oper;
	Vals vals;
}

%token <iden> IDENTIFIER
%token <type> INT_LITERAL
%token <type> BOOL_LITERAL
%token <type> REAL_LITERAL

%token ADDOP MULOP RELOP ANDOP
%token REMOP OROP NOTOP EXPOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS

%token REAL ARROW  THEN WHEN IF ELSE OTHERS ENDIF CASE ENDCASE

%type <type> type statement statement_ reductions expression relation term
	factor primary case switch exponent word phrase function_header body



%%

function:	
	function_header optional_variable body  { checkAssignment($1, $3, "Function Return"); };
	
function_header:	
	FUNCTION IDENTIFIER parameters RETURNS type ';' {$$ = $5; symbols.insert($2, $5);}  |
	error ';' {$$ = MISMATCH;};

parameters:
    parameter |
    parameter ',' parameters |
    %empty ;

parameter:
    IDENTIFIER ':' type {symbols.insert($1, $3);} ;

optional_variable:
    %empty |
	optional_variable variable ;

variable:	
	IDENTIFIER ':' type IS statement_ 
		    {if (!symbols.find($1,$5))
		     {
		         checkAssignment($3, $5, "Variable Initialization");
		         symbols.insert($1, $3);
		     } else {
		         appendError(DUPLICATE_IDENTIFIER, $1);
		     }} ;

type:
	INTEGER {$$ = INT_TYPE;}  |
	BOOLEAN {$$ = BOOL_TYPE;} |
	REAL {$$ = REAL_TYPE;} ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;
    
statement_:
	statement ';' {$$ = $1;} |
	error ';' {$$ = MISMATCH;} ;
	
statement:
	expression {$$ = $1;} |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} |
	IF expression THEN statement_ ELSE statement_ ENDIF { $$ = checkIf($2, $4, $6); }|
    CASE expression IS case OTHERS ARROW statement ';' ENDCASE  {if ($2 != INT_TYPE) appendError(GENERAL_SEMANTIC,"Case Expression Not Integer"); } ;

case:
    case switch {if (!caseSet)
                    {caseType = $2; $$ = $2; caseSet = true;}
                 else
                    { if (!($2  == caseType)) {appendError(GENERAL_SEMANTIC,"Case Types Mismatch");}
                      else   {$$ = $2;}
                    }} |
    %empty {$$ = MISMATCH;} ;

switch:
    WHEN INT_LITERAL ARROW statement_  { $$ = $4;} ;

operator:
	ADDOP |
	multiple ;

multiple:
    MULOP ;

reductions:
	reductions statement_ {$$ = checkArithmetic($1, $2);} |
	%empty {$$ = INT_TYPE;} ;
		    
expression:
	expression OROP phrase  {$$ = checkLogical($1, $3);} |
	phrase ;

phrase:
    phrase ANDOP relation { $$ = checkLogical($1, $3);} |
    relation;

relation:
	relation RELOP term {$$ = checkRelational($1, $3);}|
	term ;

term:
	term ADDOP factor {$$ = checkArithmetic($1, $3);} |
	factor ;
      
factor:
	factor MULOP exponent  {$$ = checkArithmetic($1, $3);} |
	factor REMOP exponent {$$ = checkRem($1, $3);} |
	exponent ;

exponent:
    word EXPOP exponent {$$ = checkArithmetic($1, $3);} |
    word ;

word:
    NOTOP primary {$$ = $2;} |
    primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
    BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;
    
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
