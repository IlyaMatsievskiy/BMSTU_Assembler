EXTRN num: word

STK SEGMENT para STACK 'STACK'
	db 100 dup(0)
STK ENDS

CSEG SEGMENT para public 'CODE'
	assume CS: CSEG
outputu8:
	mov dl, 0ah
	mov ah, 02
	int 21h

	xor ax, ax
	mov ax, num
	xor cx, cx
	mov bx, 8
	
	test ax, ax
	jns transform2
	
	mov cx, ax
	mov ah, 2
	mov dl, '-'
	int 21h
	mov ax, cx
	neg ax
	xor cx, cx
		
transform2:
	xor	dx, dx
	div bx
	push dx
	inc cx
	test ax, ax
	jnz transform2
	mov ah, 2
	
output8:
	pop bx
	add bx, 30h
	mov dl, bl
	int 21h
	loop output8

	mov dl, 0ah
	mov ah, 02
	int 21h

	ret
CSEG ENDS
PUBLIC outputu8
END outputu8