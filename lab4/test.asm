.model small
.stack 100h

.data
matrix db 1, 2, 3, 4
       db 5, 6, 7, 8
       db 9, 10, 11, 12
rows equ 3
cols equ 4

.code
main PROC
    mov ax, @data
    mov ds, ax

    ; Вызываем функцию для инвертирования четных столбцов матрицы
    mov bx, offset matrix
    mov cx, rows
    mov dx, cols
    call invert_even_columns

    ; Выводим результат
    mov bx, offset matrix
    mov cx, rows
print_matrix_loop:
    mov dx, cols
print_row_loop:
    mov al, [bx]
    call print_num
    inc bx
    dec dx
    jnz print_row_loop

    mov ah, 2h  ; Переход на новую строку
    int 21h

    loop print_matrix_loop

    mov ah, 4Ch ; Выход из программы
    int 21h

main ENDP

invert_even_columns PROC
    push bp
    mov bp, sp

    mov di, [bp + 4] ; Загружаем адрес матрицы из аргументов функции
    mov cx, [bp + 6] ; Загружаем количество строк из аргументов функции
    mov dx, [bp + 8] ; Загружаем количество столбцов из аргументов функции

    xor si, si       ; Индекс строки (сброшен в 0)

invert_columns_loop:
    mov di, si       ; Копируем индекс строки в di для использования внутри цикла столбцов
    xor dx, dx       ; Индекс столбца (сброшен в 0)
invert_next_column:
    cmp dx, cols     ; Проверка, достигли ли конца строки
    je next_row      ; Если да, переходим к следующей строке
    mov ax, dx       ; Загрузка индекса столбца в ax
    test al, 1       ; Проверка на четность
    jnz not_even     ; Если столбец нечетный, пропускаем инверсию
    push ax         ; Сохраняем индекс столбца на стек
    mov si, di       ; Загрузка индекса строки в si
    mul cx           ; Умножение индекса строки на количество столбцов
    add si, ax       ; Добавление индекса столбца
    mov al, [si]     ; Загрузка значения элемента матрицы
    neg al           ; Инвертирование значения элемента
    mov [si], al     ; Сохранение инвертированного значения
    pop ax          ; Восстанавливаем индекс столбца из стека
not_even:
    inc dx           ; Увеличение индекса столбца
    jmp invert_next_column
next_row:
    inc si           ; Увеличение индекса строки
    loop invert_columns_loop

    pop bp
    ret 6            ; Удаляем аргументы функции из стека и возвращаемся

invert_even_columns ENDP

print_num PROC
    add al, 30h      ; Преобразуем число в ASCII символ
    mov ah, 02h      ; Функция вывода символа
    int 21h          ; Выводим символ
    ret
print_num ENDP

END main
