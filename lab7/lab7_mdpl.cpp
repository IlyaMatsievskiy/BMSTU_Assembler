#define CRT_SECURE_NO_WARNINGS
#include <iostream>
#include <string>

using namespace std;

extern "C" void asm_strcpy(char* dest, const char* source, int size);

size_t asm_strlen(const char* str) {
	size_t len = 0;
	_asm {
		mov ecx, -1
		mov al, '\0'
		mov edi, str
		repne scasb
		not ecx
		dec ecx
		mov len, ecx
	};
	return len;
}

int main(void) {
	setlocale(0, "");
	const char* num1 = "12345";
	const char* num2 = "123";
	const char* num3 = "1234";
	char *dest = (char*)calloc(100, sizeof(char));

	cout << "Вычисление длин строк с помощью функции c++ и ассемблерной вставки:" << endl;
	cout << "Первый тест: строка_1: " << num1 << "  длина_c++: " << strlen(num1) << "  длина_asm: " << asm_strlen(num1) << endl;
	cout << "Второй тест: строка_2: " << num2 << "  длина_c++: " << strlen(num2) << "  длина_asm: " << asm_strlen(num2) << endl;
	cout << "Третий тест: строка_3: " << num3 << "  длина_c++: " << strlen(num3) << "  длина_asm: " << asm_strlen(num3) << endl;
	cout << endl;

	cout << "Копирование строк с определенной длиной с помощью ассемблера:" << endl;
	asm_strcpy(dest, num1, strlen(num1));
	cout << "Первый тест: source: " << num1 << " destination: " << dest << " длина: " << strlen(num1) << endl;
	memset(dest, 0, sizeof(char) * 100);
	asm_strcpy(dest, num2, 10);
	cout << "Второй тест: source: " << num2 << " destination: " << dest << " длина: " << 10 << endl;
	memset(dest, 0, sizeof(char) * 100);
	asm_strcpy(dest, num3, 1);
	cout << "Третий тест: source: " << num3 << " destination: " << dest << " длина: " << 1 << endl;
	free(dest);
	return 0;
}
