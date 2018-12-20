// Compiler Theory and Design
// Duane J. Jarc

// This file contains the bodies of the type checking functions

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
	if (lValue == INT_TYPE && rValue == REAL_TYPE) {
		appendError(GENERAL_SEMANTIC, "Illegal Narrowing " + message);
		return;
	}
	//Widening variables ok
	if (rValue == INT_TYPE && lValue == REAL_TYPE) { ;
		return;
	}

	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Numeric Type Required");
		return MISMATCH;
	}
	if ((left == INT_TYPE && right == REAL_TYPE) || (left == REAL_TYPE && right == INT_TYPE))
	{
		return REAL_TYPE;
	}
	if (left == REAL_TYPE && right == REAL_TYPE) {
		return REAL_TYPE;
	}
	return INT_TYPE;
}



Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}
		return BOOL_TYPE;

}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}

Types checkIf(Types exp, Types left, Types right)
{
	if (exp != BOOL_TYPE) {
		appendError(GENERAL_SEMANTIC, "If Expression Must Be Boolean");
		return MISMATCH;
	}
	if (left != right) {
		appendError(GENERAL_SEMANTIC, "If-Then Type Mismatch");
		return MISMATCH;
	}
	return right;
}

Types checkRem(Types left, Types right)
{
	if (left != INT_TYPE || right != INT_TYPE) {
		appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer Operand");
		return MISMATCH;
	}
	return INT_TYPE;
}

void typeCheck(Types type) {
	if (type == BOOL_TYPE) {
		printf("Boolean");
	}
	if (type == INT_TYPE) {
		printf("int");
	}
	if (type == REAL_TYPE) {
		printf("Real");
	}
}