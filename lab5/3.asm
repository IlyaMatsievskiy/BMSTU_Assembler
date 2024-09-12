EXTRN num: word

STK SEGMENT para STACK 'STACK'
	db 100 dup(0)
STK ENDS

CSEG SEGMENT para public 'CODE'
	assume CS: CSEG
outputs2:
	mov dl, 0ah
	mov ah, 02
	int 21h

	xor ax, ax
	mov ax, num
	xor cx, cx
	mov bx, 2
		
transform1:
	xor	dx, dx
	div bx
	push dx
	inc cx
	test ax, ax
	jnz transform1
	
	mov ah, 2
	
output2:
	pop bx
	add bx, 30h
	mov dl, bl
	int 21h
	loop output2
	
	mov dl, 0ah
	mov ah, 02
	int 21h

	ret
CSEG ENDS
PUBLIC outputs2
END outputs2