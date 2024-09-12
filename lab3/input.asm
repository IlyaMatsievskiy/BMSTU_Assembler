PUBLIC number
EXTRN outt: far

SSTK SEGMENT para STACK 'STACK'
	db 100 dup(0)
SSTK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
   number db 0
   msg_num db "Input number: ", '$'
DSEG ENDS

CSG1 SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSG1, DS:DSEG

main:
   mov ax, DSEG
   mov ds, ax
   mov dx, OFFSET msg_num
   mov ah, 09h
   int 21h
   mov ah, 01h
   int 21h
   mov number, al
   jmp outt
CSG1 ENDS
    END main