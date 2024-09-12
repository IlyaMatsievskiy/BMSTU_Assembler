EXTRN number: byte
PUBLIC outt

DSG2 SEGMENT PARA PUBLIC 'DATA'
   msg_num_out db 13, 10, "Output number: ", '$'
DSG2 ENDS

CSG2 SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSG2, DS:DSG2

outt:
	mov ax, seg number
	mov es, ax
	mov bh, es:number

	mov ax, DSG2
	mov ds, ax

	mov dx, OFFSET msg_num_out
	mov ah, 09h
    int 21h
	cmp bh, '2'
	jle print_neg

	mov dl, es:number
	sub dl, 2
	mov ah, 02h
	int 21h
	jmp print_end

print_neg:
	mov dl, '-'
    mov ah, 02h
    int 21h
	mov dl, '2'
	sub dl, es:number
	add dl, '0'
	mov ah, 02h
	int 21h

print_end:
   mov ah, 4Ch
   int 21h

CSG2 ENDS
    END