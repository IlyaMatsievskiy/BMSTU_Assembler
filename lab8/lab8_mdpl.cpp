#include <iostream>
#include <cmath>
#include "ams.h"
#include "ams_asm.h"
#include "pi.h"

using namespace std;

double f(double x) {
	double i = 0.0;
	double five = 5.0;
	double two = 2.0;
	__asm {
		fld qword ptr[x];
		fmul st, st;
		fsub qword ptr[five];
		fsin;
		fmul qword ptr[two];
		fstp qword ptr[i];
	}
	return i;
}

double chord_method(double a, double b, int iterations) {
	for (int i = 0; i < iterations; i++)
	{
		if (fabs(f(b) - f(a)) < 1e-6)
			break;
		double fa = f(a);
		double fb = f(b);
		__asm {
			fld qword ptr[a]
			fld qword ptr[b]
			fsub st(0), st(1)
			fmul qword ptr[fa]
			fld qword ptr[fb]
			fsub qword ptr[fa] 
			fdivp st(1), st(0) 
			fsubp st(1), st(0) 
			fstp qword ptr[a]
		}
		// a = (a - b) * fa / (fb - fa) - (a - b)
	}
	return a;

}

int main() {
	cout << "========== Float 32 ==========" << endl;
	cout << "[Add]     " << endl;
	cout << "Non-asm:  " << add_c<float>(100000000, 123456, 654321) << " ms" << endl;
	cout << "Asm:      " << add_asm<float>(100000000, 123456, 654321) << " ms" << endl;
	cout << "[Mul]     " << endl;
	cout << "Non-asm:  " << mul_c<float>(100000000, 123456, 654321) << " ms" << endl;
	cout << "Asm:      " << mul_asm<float>(100000000, 123456, 654321) << " ms" << endl;

	cout << "========== Double 64 ==========" << endl;
	cout << "[Add]     " << endl;
	cout << "Non-asm:  " << add_c<double>(100000000, 123456, 654321) << " ms" << endl;
	cout << "Asm:      " << add_asm<double>(100000000, 123456, 654321) << " ms" << endl;
	cout << "[Mul]     " << endl;
	cout << "Non-asm:  " << mul_c<double>(100000000, 123456, 654321) << " ms" << endl;
	cout << "Asm:      " << mul_asm<double>(100000000, 123456, 654321) << " ms" << endl;

	std::cout << "========== Sin (pi)  ==========" << std::endl;
	std::cout << "CPU (3.14):       " << sin(3.14) << std::endl;
	std::cout << "CPU (3.141596):   " << sin(3.141596) << std::endl;
	std::cout << "FPU:              " << sin(get_pi()) << std::endl;

	std::cout << "========== Sin (pi/2)  ==========" << std::endl;
	std::cout << "CPU (3.14):       " << sin(3.14 / 2) << std::endl;
	std::cout << "CPU (3.141596):   " << sin(3.141596 / 2) << std::endl;
	std::cout << "FPU:              " << sin(get_half_pi()) << std::endl;


	double a, b;
	int iterations;
	cout << "Enter the interval [a, b]: " << endl;
	cout << "Left interval: "; 
	cin >> a;
	cout << "Right interval: ";
	cin >> b;
	cout << "Enter the number of iterations: ";
	cin >> iterations;

	double root = chord_method(a, b, iterations);

	cout << "The root of 2*sin(x^2 - 5) on the interval [" << a << ", " << b << "] is " << root << endl;

	return 0;
}
