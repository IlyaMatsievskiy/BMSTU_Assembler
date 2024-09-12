#pragma once

double get_pi(void)
{
	double fpu_pi;

	__asm {
		fldpi; загрузить значение pi из FPU
		fstp qword ptr[fpu_pi]; сохранить значение pi в переменной fpu_pi и извлечь его из FPU
	}

	return fpu_pi;
}

double get_half_pi(void)
{
	double fpu_pi;
	int del = 2;

	__asm {
		fldpi; загрузить значение pi в FPU
		fild dword ptr[del]; загрузить целочисленное значение del в стек FPU
		fdiv; Поделить pi на del и сохранить результат в вершине стека FPU
		fstp qword ptr[fpu_pi]; сохранить результат в переменной fpu_pi и извлечь его из стека FPU
	}

	return fpu_pi;
}


