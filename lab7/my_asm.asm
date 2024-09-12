.686
.MODEL FLAT, C
.STACK

.CODE

asm_strcpy PROC
    push ebp
	mov ebp, esp
	push edi
    push esi

	mov edi, [ebp + 8]    ; dst
	mov esi, [ebp + 12]   ; src
	mov ecx, [ebp + 16]   ; size
    
    cmp edi, esi
    jbe copy               ; dst <= src

    mov eax, edi
    sub eax, esi
    cmp eax, ecx
    ja copy                ; dst - src > size
    
    ; dst > src и dst - src < len => копирование с конца
    add edi, ecx
    dec edi
    add esi, ecx
    dec esi
    std             ; DF = 1

    copy:
        rep movsb
        cld             ; DF = 0

    pop esi
    pop edi
	pop ebp
    ret
asm_strcpy ENDP
END
