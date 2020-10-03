/*
	Garinn Morton 
	Assembly
	Final
*/

#include <stdio.h>

extern "C" double harm();

int main()
{
	double result = -999;
	printf("%s\n\n", "Welcome to Harmonic Sum Programming by Garinn Morton.");
	result = harm();
	printf("\n%s%lf\n", "The main program received this value: ", result);
	printf("%s\n", "The program has returned 0 to the operating system.");
	return 0;
}