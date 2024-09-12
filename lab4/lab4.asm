STK SEGMENT PARA STACK 'STACK'    
    DB 250h DUP (?)
STK ENDS

DSG SEGMENT PARA COMMON 'DATA'
    matrix DB 81 DUP(0) ; массив из 81 элемента, каждый элемент размером 1 байт
    rows DB 0
    cols DB 0
    msg_cols DB "Enter the number of matrix columns: ", '$'
    msg_rows DB "Enter the number of matrix rows: ", '$'
    msg_elem DB "Enter matrix element: ", '$'
    msg_final DB "Result matrix: ", '$'
    max_matrix_size DB 9
    ax_buff DW 0
DSG ENDS

CSG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSG, DS:DSG, SS:STK

; код символа помещается в AL
getc proc near
    mov AH, 01h
    int 21h
    ret
getc endp

; вывод символа, хранящегося в DL
putc proc near
    mov AH, 02h
    int 21h
    ret
putc endp

; переход на новую строку
new_line proc near
    mov AH, 02h
    mov DL, 13
    int 21h
    mov AH, 02h
    mov DL, 10
    int 21h
    ret
new_line endp

put_space proc near
    mov AH, 02h
    mov DL, 32
    int 21h
    ret
put_space endp

; выводит на экран строку адрес которой храниться в DS:DX
print_msg proc near
    mov AH, 09h
    int 21h
    ret
print_msg endp

scan_matrix proc near
    mov DX, OFFSET msg_rows
    call print_msg
    call getc
    mov rows, AL
    sub rows, '0' ; преобраование символа в число
    call new_line
    mov DX, OFFSET msg_cols
    call print_msg
    call getc
    mov cols, AL
    sub cols, '0' ; преобраование символа в число
    call new_line
    mov CX, 0
    mov CL, rows
    mov BX, 0
    rows_loop:
        mov SI, CX
        mov CL, cols
        mov DI, 0
        cols_loop:
            mov DX, OFFSET msg_elem
            call print_msg
            call getc
            mov matrix[BX][DI], AL
            inc DI
            call new_line
            loop cols_loop
        add BL, max_matrix_size
        mov CX, SI
        loop rows_loop
    ret
scan_matrix endp

print_matrix proc near
    mov DX, OFFSET msg_final
    call print_msg
    call new_line
    mov CX, 0
    mov CL, rows
    mov BX, 0
    rows_loop:
        mov SI, CX
        mov CL, cols
        mov DI, 0
        cols_loop:
            mov DL, matrix[BX][DI]
            call putc
            call put_space
            inc DI
            loop cols_loop
        add BL, max_matrix_size
        mov CX, SI
        call new_line
        loop rows_loop
    ret
print_matrix endp



reverse_row proc near
    xor cx, cx
    mov cl, cols
    xor di, di
    xor bx, bx
    xor ax, ax
    mov di, 0
    mov al, max_matrix_size
    cols_num:

        push ax
        mov ax, 0
        mov al, rows
        mov si, ax
        pop ax
        test di, 1
        jnz not_chet
        incr:
            mov ax_buff,ax
            mov ax,0
            mov al, matrix[bx][di]
            push ax
            mov ax,ax_buff

            add bx, ax
            dec si
            jnz incr

            push ax
            mov ax, 0
            mov al, rows
            mov si, ax
            pop ax
            xor bx, bx  
        decr:

            mov ax_buff,ax
            pop ax
            mov matrix[bx][di], al
            mov ax,ax_buff

            add bx, ax
            dec si
            jnz decr
        not_chet:
            inc di
            loop cols_num
    ret
reverse_row endp
 

main:
    mov AX, DSG
    mov DS, AX
    call scan_matrix
    mov SI, 1
    call reverse_row
    call print_matrix
    mov AH, 4Ch
    int 21h
CSG ENDS
    END main