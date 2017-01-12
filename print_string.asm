[org 0x7c00]

mov ah, 0x0e

mov bx, STRING
call print_string

jmp $

STRING:
    db 'test', 0

print_string:
    mov cl, [bx]
    cmp cl, 0
    jne bx_add ; if not equals 0, jmp
    ret

bx_add:
    mov al, [bx]
    int 0x10
    add bx, 1
    jmp print_string

times 510-($-$$) db 0
dw 0xaa55

