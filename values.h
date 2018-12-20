// CMSC 430
// Duane J. Jarc

//editied for project 3 by Daniel Russell

// This file contains function definitions for the evaluation functions

typedef char* CharPtr;
enum Operators {LESS, GREAT, LESSEQUAL, EQUAL, GREATEQUAL, NOTEQUAL, ADD, MULTIPLY, EXPONENT, SUB, REM, DIV};

int evaluateReduction(Operators operator_, int head, int tail);
int evaluateRelational(int left, Operators operator_, int right);
int evaluateArithmetic(int left, Operators operator_, int right);

