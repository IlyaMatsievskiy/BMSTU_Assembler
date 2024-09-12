
EXTRN num: word
EXTRN num_str: byte

DSEG SEGMENT para public 'DATA'
	inp_num db'Input number: ', '$'
DSEG ENDS

CSEG SEGMENT para public 'code'
	assume CS:CSEG, DS:DSEG
str_to_int:
	mov dl, 0ah
	mov ah, 02
	int 21h
	lea dx, inp_num
	mov ah, 09
	int 21h
	lea dx, num_str
	mov ah, 0Ah
	int 21h
	
	xor ax, ax
	mov cl, 4
	mov di, 2
	cmp byte ptr num_str[di], '-'
	jnz transform
	mov si, 1
	inc di
	
transform:
	xor bx, bx
	mov bl, num_str[di]
	cmp bx, 0Dh
	je endofcycle
	cmp bx, 57
	jb digit
	cmp bx, 'G'
	jb letter
digit:
	sal ax, cl
	sub bl, '0'
	add ax, bx
	jmp endofif
letter:
	sal ax, cl
	sub bl, 37h
	add ax, bx
	jmp endofif
endofif:
	inc di	
	jmp transform
endofcycle:
	cmp si, 1
	jnz eop
	neg ax
eop:
	xchg num, ax
	
	ret
CSEG ENDS
PUBLIC str_to_int
END str_to_int
