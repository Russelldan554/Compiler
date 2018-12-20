// CMSC 430
// Duane J. Jarc

//Edited for project 3 by Daniel Russell

// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

int evaluateReduction(Operators operator_, int head, int tail)
{
	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}

int evaluateRelational(int left, Operators operator_, int right)
{
	int result;
	switch (operator_)
	{
		case LESS:
			result = left < right;
			break;
		case GREAT:
			result = left > right;
			break;
		case LESSEQUAL:
			result = left <= right;
			break;
		case GREATEQUAL:
			result = left >= right;
			break;
		case NOTEQUAL:
			result = left != right;
			break;
		case EQUAL:
			result = left == right;
			break;
	}
	return result;
}

int evaluateArithmetic(int left, Operators operator_, int right)
{
	int result;
	switch (operator_)
	{
		case ADD:
			//printf("\nadd %d %d", right, left);
			result = left + right;
			break;
		case EXPONENT:
			//printf("\nexp %d %d", right, left);
			result = pow(left, right);
			break;
		case MULTIPLY:
			//printf("\nmul %d %d", right, left);
			result = left * right;
			break;
		case SUB:
			//printf("\nsub %d %d", right, left);
			result = left - right;
			break;
		case DIV:
			//printf("\ndiv %d %d", right, left);
			result = left / right;
			break;
		case REM:
			//printf("\nrem %d %d", right, left);
			result = left % right;
			break;

	}
	return result;
}

