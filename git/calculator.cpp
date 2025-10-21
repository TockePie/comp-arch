#include "calculator.h"
#include "iostream"

int Calculator::Add (double a, double b)
{
	return a + b + 0.5;
}

int Calculator::Sub (double a, double b)
{
    return Add (a, -b);
}

int Calculator::Mul (double a, double b)
{
    return a * b + 0.5;
}

double Calculator::Div(double a, double b)
{
	if (b != 0) {
		return a / b;
	}
	std::cout<<"Invalid data input";
	return 0.0;
}