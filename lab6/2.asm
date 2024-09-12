.model tiny
.code
org 100h 

main:
    jmp init
	
    handler_addr    dd 0 
    is_init         db 1
    cur_speed       db 1Fh
    cur_time        db 0

inc_input_speed proc near
    push ax
    push cx
    push dx

    mov ah, 02h
    int 1Ah

    cmp dh, cur_time
    je skip_speed_change

    mov cur_time, dh
    dec cur_speed

    cmp cur_speed, 1Fh
    jbe set_speed
    
    mov cur_speed, 1Fh

set_speed:
    mov al, 0F3h
    out 60h, al

    mov al, cur_speed
    out 60h, al

skip_speed_change:
    pop dx
    pop cx
    pop ax
    jmp dword ptr cs:handler_addr
inc_input_speed endp

init:
    mov ax, 351Ch
    int 21h

    cmp es:is_init, 1
    je exit

    mov word ptr handler_addr, bx
    mov word ptr handler_addr[2], es

    mov ax, 251Ch
    mov dx, offset inc_input_speed
    int 21h

    mov dx, offset init_msg
    mov ah, 09h
    int 21h

    mov dx, offset init
    int 27h

exit:
    mov dx, offset exit_msg
    mov ah, 09h
    int 21h

    
    mov al, 0F3h
    out 60h, al

    mov al, 0
    out 60h, al
    
    mov dx, word ptr es:handler_addr                       
    mov ds, word ptr es:handler_addr[2]
    mov ax, 251ch
    int 21h

    mov ah, 49h
    int 21h

    mov ax, 4c00h
    int 21hû
	
    init_msg db 'New interrupt handler installed.', '$'
    exit_msg db 'New interrupt handler uninstalled.', '$'
    
END main