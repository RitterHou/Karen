[org 0x7c00]            ; means all the address in this file is begining in 0x7c00(equals to segment value is 0x7c0)

mov ah, 0x0e            ; BIOS interupt 0x10 need ah is 0x0e, no reason

mov bx, STRING          ; STRING is just a address
call print_string

jmp $                   ; jmp to current address

STRING:
    db 'test', 0        ; build a string in this address, and it end with a 0

print_string:
    mov cl, [bx]        ; the value of bx is STRING, so [bx] is the value which in address STRING
    cmp cl, 0           ; cmp cl with 0
    jne bx_add          ; if cl not equals 0, jmp to bx_add(until [bx] is 0, this instruction is running)
    ret

bx_add:
    mov al, [bx]
    int 0x10            ; when execute BISO interupt 0x10, it with print the value of register al into screen
    add bx, 1           ; bx plus one, means bx is pointing the next letter noe
    jmp print_string

times 510-($-$$) db 0   ; $ means current address, $$ means the start address, so 510-($-$$) means how many 0 we should write in this file after current address, then we can make this file is 510b. times x i means run i x times, so this instruction means we just run db 0(write a 0 here) 510-($-$$) times.
dw 0xaa55               ; write word(2 bytes) 0xaa55 at the end of this file, it will make this file bootable.

