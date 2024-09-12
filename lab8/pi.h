#pragma once

double get_pi(void)
{
	double fpu_pi;

	__asm {
		fldpi; ��������� �������� pi �� FPU
		fstp qword ptr[fpu_pi]; ��������� �������� pi � ���������� fpu_pi � ������� ��� �� FPU
	}

	return fpu_pi;
}

double get_half_pi(void)
{
	double fpu_pi;
	int del = 2;

	__asm {
		fldpi; ��������� �������� pi � FPU
		fild dword ptr[del]; ��������� ������������� �������� del � ���� FPU
		fdiv; �������� pi �� del � ��������� ��������� � ������� ����� FPU
		fstp qword ptr[fpu_pi]; ��������� ��������� � ���������� fpu_pi � ������� ��� �� ����� FPU
	}

	return fpu_pi;
}


