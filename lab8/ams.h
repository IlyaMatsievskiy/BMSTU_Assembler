#pragma once
#include <chrono>
#include "ams_asm.h"

template <typename T>
uint64_t add_c(size_t n, T a, T b)
{
	T c;
	uint64_t start = time_now();
	for (size_t i = 0; i < n; i++)
		a + b;
	return time_now() - start;
}

template <typename T>
uint64_t mul_c(size_t n, T a, T b)
{
	T c;
	uint64_t start = time_now();
	for (size_t i = 0; i < n; i++)
		a * b;
	return time_now() - start;
}

