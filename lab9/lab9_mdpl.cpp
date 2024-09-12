#include <iostream>

using namespace std;

#define MATRIX_SIZE 10

void scanMatrix(double matrix[MATRIX_SIZE][MATRIX_SIZE], size_t n, size_t m){
	for (size_t i = 0; i < n; ++i)
		for (size_t j = 0; j < m; ++j)
			cin >> matrix[i][j];
}

void printMatrix(double matrix[MATRIX_SIZE][MATRIX_SIZE], size_t n, size_t m){
	for (size_t i = 0; i < n; ++i){
		for (size_t j = 0; j < m; ++j)
			cout << matrix[i][j] << " ";
		cout << endl;
	}
}

int main(){
	double matrix1[MATRIX_SIZE][MATRIX_SIZE] = { 0 };
	double matrix2[MATRIX_SIZE][MATRIX_SIZE] = { 0 };
	double matrix3[MATRIX_SIZE][MATRIX_SIZE] = { 0 };
	size_t height_1;
	size_t width_1;
	size_t height_2;
	size_t width_2;

	cout << "Input first matrix size: ";
	cin >> height_1 >> width_1;
	cout << "Input first matrix elements:" << endl;
	scanMatrix(matrix1, height_1, width_1);
	cout << "Input second matrix size: ";
	cin >> height_2 >> width_2;
	if (width_1 != height_2){
		cout << "Sizes error" << endl;
		return 0;
	}
	cout << "Input second matrix elements:" << endl;
	scanMatrix(matrix2, height_2, width_2);

	__asm{
		// Транспонирвание
		mov ecx, height_2
		mov esi, 0
		rows_label:
			push ecx
			mov ecx, width_2
			mov edi, esi
		cols_label :
			mov eax, MATRIX_SIZE
			mul esi
			add eax, edi
			mov ebx, eax

			mov eax, MATRIX_SIZE
			mul edi
			add eax, esi

			vmovsd xmm0, matrix2[ebx]
			vmovsd xmm1, matrix2[eax]
			vmovsd matrix2[ebx], xmm1
			vmovsd matrix2[eax], xmm0

			add edi, 8
			loop cols_label
			pop ecx
			add esi, 8
			loop rows_label

			// Умножение
			mov ecx, height_1
			mov esi, 0
		rows1:
			push ecx
			mov ecx, width_2
			mov edi, 0
		rows2 :
			push ecx
			mov eax, width_1
			mov ecx, 4
			mov edx, 0
			div ecx
			mov ecx, eax

			cmp edx, 0
			je skip_inc
			inc ecx
		skip_inc :
			mov eax, MATRIX_SIZE
			mul esi
			mov ebx, eax
			mov eax, MATRIX_SIZE
			mul edi
			mov edx, eax
			mov eax, ebx
			add eax, edi
			vpxor xmm3, xmm3, xmm3
		cols :
			vmovupd ymm0, [matrix1 + ebx]
			vmovupd ymm1, [matrix2 + edx]
			vmulpd ymm2, ymm1, ymm0
			vhaddpd ymm0, ymm2, ymm2
			vextractf128 xmm1, ymm0, 1
			vaddsd xmm3, xmm3, xmm1
			vaddsd xmm3, xmm3, xmm0
			add ebx, 32
			add edx, 32
			loop cols
			vmovsd matrix3[eax], xmm3
			pop ecx
			add edi, 8
			loop rows2
			pop ecx
			add esi, 8
			dec ecx
			jnz rows1
	}

	cout << "Result:" << endl;
	printMatrix(matrix3, height_1, width_2);

	return 0;
}