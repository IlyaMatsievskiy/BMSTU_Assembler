stk segment stack
    db 256 dup (?)
stk ends

datas segment
    row_ask db "Enter rows: $"
    col_ask db 13,10,"Enter cols: $"
    mat_ask db 13,10,"Enter matrix:",13,10,"$"

    inp_row db 0
    inp_col db 0

    out_row db 0
    out_col db 0

    inp_mat db 81 dup (0)
    out_mat db 81 dup (0)
datas ends

code_main segment 'code'
    assume cs:code_main, ds:datas
main:
    mov ax,datas
    mov ds,ax

    mov dx,offset row_ask
    mov ah,09h
    int 21h

    mov ah,01h
    int 21h
    sub al,30h
    mov inp_row,al
    
    mov dx,offset col_ask
    mov ah,09h
    int 21h
    
    mov ah,01h
    int 21h
    sub al,30h
    mov inp_col,al

    mov dx,offset mat_ask
    mov ah,09h
    int 21h


    ; ���� �������
    mov bx,offset inp_mat ; ��������� �� ������� ������� �������� �������
    mov cl,inp_row ; ������� ����� ��� ����� �����
    mov ch,inp_col ; ������� �������� ��� ����� �����
    inp_loop_row:
        inp_loop_col:
            mov ah,01h
            int 21h
            sub al,30h
            mov [bx],al

            add bx,1 ; ������� �� ��������� �������
            dec ch ; ���������� �������� ��������
            jnz inp_loop_col
        mov ch,inp_col ; �������������� �������� ��������

        ; ���������� � ������ �������� 9 - �����_��������, �.�. ������� ��������
        add bx,9 
        mov ax,0 ; ���������� ax, ��� ��� ����������� bx - 2 �����, � inp_col - 1
        mov al,inp_col
        sub bx,ax

        ; ������� �� ��������� ������
        mov dl,13
        mov ah,02h
        int 21h
        mov dl,10
        int 21h
        
        dec cl ; ���������� �������� �����
        jnz inp_loop_row

    
    mov dl,13
    mov ah,02h
    int 21h
    mov dl,10
    int 21h

    ; ��������� �������
    mov bx,offset inp_mat ; �������� ������� �������
    mov ax,offset out_mat ; �������� �������� �������
    mov si,ax ; ��������� �� ������ ������� ��������� �������
    
    mov cl,inp_row ; ������� �����
    mov ch,inp_col ; ������� �������� ��� ����� ���������

    mov ax,0
    mov al,cl
    add si,ax
    dec si ; ��������� ��������� �� ��������� ������� �������� �������

    mov out_row,ch
    mov out_col,cl

    new_loop_row:
        new_loop_col:
            mov al,[bx]
            mov [si],al

            add bx,1
            add si,9

            dec ch
            jnz new_loop_row
        mov ch,inp_col

        add bx,9
        mov ax,0
        mov al,inp_col
        sub bx,ax

        mov ax,offset out_mat
        mov si,ax
        mov ax,0
        mov al,cl
        add si,ax
        sub si,2
        
        dec cl
        jnz new_loop_col

    ; ����������� �������
    mov bx,offset inp_mat
    mov ax,offset out_mat
    mov si,ax
    
    mov cl,out_row
    mov ch,out_col
    
    mov inp_row,cl
    mov inp_col,ch

    copy_loop_row:
        copy_loop_col:
            mov al,[si]
            mov [bx],al

            add bx,1
            add si,1

            dec ch
            jnz copy_loop_row
        mov ch,inp_col

        add bx,9
        add si,9

        mov ax,0
        mov al,inp_col

        sub bx,ax
        sub si,ax
        
        dec cl
        jnz copy_loop_col

    ; ����� �������
    mov bx,offset inp_mat
    mov cl,inp_row
    mov ch,inp_col
    out_loop_row:
        out_loop_col:
            mov ah,02h
            mov dl,[bx]
            add dl,30h
            int 21h

            add bx,1
            dec ch
            jnz out_loop_col
        mov ch,inp_col
        add bx,9
        mov ax,0
        mov al,inp_col
        sub bx,ax

        mov dl,13
        mov ah,02h
        int 21h
        mov dl,10
        int 21h
        
        dec cl
        jnz out_loop_row

    mov ah,4Ch
    int 21h
code_main ends
    end main