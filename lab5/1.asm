EXTRN str_to_int: near
EXTRN outputs2: near
EXTRN outputu8: near
PUBLIC num_str, num

STK SEGMENT para STACK 	'STACK'
	db 100 dup(0)
STK ENDS

DSEG SEGMENT para public 'DATA'
	num_str db 16 dup('$')
	num dw 1 dup(0)
	smt db 3 dup(1)
	header db 'Menu:', 0ah, '$'
	variants db '1 - input number', 10, '2 - output in 8', 10, '3 - output in 2', 10, '$'
	exitvar db '4 - close program', 10, '$'
	choice db 'Your choice: ', '$'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, SS:STK, DS:DSEG
main:
	mov ax, DSEG
	mov ds, ax
	mov dl, 0ah
	mov ah, 02
	int 21h
	
	mov ax, str_to_int
	mov byte ptr smt[0], al
	mov ax, outputu8
	mov byte ptr smt[1], al
	mov ax, outputs2
	mov byte ptr smt[2], al
	
menu:
	lea dx, header
	mov ah, 09
	int 21h
	lea dx, variants
	int 21h
	lea dx, exitvar
	int 21h
	lea dx, choice
	int 21h	
	mov ah, 1
	int 21h
	
	cmp al, 34h
	je exit
	xor bx, bx
	mov bl, al
	sub bx, 31h
	xor ax, ax
	mov al, [smt + bx]
	call ax
	jmp menu	
exit:
	mov ax, 4c00h
	int 21h
CSEG ENDS
END main
