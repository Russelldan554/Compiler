// Compiler Theory and Design
// Dr. Duane J. Jarc

//Edited by Daniel Russell for Project 1 and 2 on: 11/15/2018

// This file contains the bodies of the functions that produces the compilation
// listing

#include <cstdio>
#include <string>
#include <queue>

using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int semanticErrors = 0;
static int syntacticErrors = 0;
static int lexicalErrors = 0;
static std::queue <string> errorQue;

static void displayErrors();

void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

int lastLine() {
    printf("\r");
    displayErrors();
    if (totalErrors > 0) {
        printf("Lexical Errors %d \n", lexicalErrors);
        printf("Syntactic Errors %d \n", syntacticErrors);
        printf("Semantic Errors %d \n", semanticErrors);
    } else
        printf("Compiled Succesfully \n");
	return totalErrors;
}
    
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

    errorQue.push(messages[errorCategory] + message);

    if (errorCategory == LEXICAL) {
        lexicalErrors++;
    }
    if (errorCategory == SYNTAX) {
        syntacticErrors++;
    }
    if (errorCategory == GENERAL_SEMANTIC) {
        semanticErrors++;
    }
    if (errorCategory == DUPLICATE_IDENTIFIER) {
        semanticErrors++;
    }
    if (errorCategory == UNDECLARED) {
        semanticErrors++;
    }
	totalErrors++;
}

void displayErrors()
{
	while(!errorQue.empty()) {
        printf("%s\n",  errorQue.front().c_str());
        errorQue.pop();
    }

}
