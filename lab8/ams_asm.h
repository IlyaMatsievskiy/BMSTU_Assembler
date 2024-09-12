#pragma once

#include <chrono>

static uint64_t time_now() {
	return std::chrono::duration_cast<std::chrono::milliseconds>(std::chrono::system_clock::now().time_since_epoch()).count();
}


template <typename T>
uint64_t add_asm(size_t n, T a, T b)
{
	T c;
	uint64_t start = time_now();
	for (size_t i = 0; i < n; i++)
	{
		__asm {
			fld qword ptr[a];
			fld qword ptr[b];
			faddp st(1), st(0);
			fstp qword ptr[c];
		}
	}
	return time_now() - start;
}

template <typename T>
uint64_t mul_asm(size_t n, T a, T b)
{
	T c;
	uint64_t start = time_now();
	for (size_t i = 0; i < n; i++)
	__asm {
		fld qword ptr[a];
		fld qword ptr[b]; 
		fmulp st(1), st(0);
		fstp qword ptr[c];
	}
	return time_now() - start;
}
