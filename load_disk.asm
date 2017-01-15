[org 0x7c00]
mov ah, 0x0e
mov [BOOT_DRIVE], dl ; BIOS stores our boot drive in DL, so it’s best to remember this for later.

mov bp, 0x8000 ; Here we set our stack safely out of the
mov sp, bp ; way, at 0x8000

mov bx, 0x9000 ; Load 5 sectors to 0x0000(ES):0x9000(BX)
mov dh, 5 ; from the boot disk.
mov dl, [BOOT_DRIVE]
call disk_load
mov dx, [0x9000] ; Print out the first loaded word, which
call print_hex ; we expect to be 0xdada , stored
; at address 0x9000
mov dx, [0x9000 + 512] ; Also, print the first word from the
call print_hex ; 2nd loaded sector: should be 0xface
mov bx, BOOT
call print_string
jmp $

; load DH sectors to ES:BX from drive DL
disk_load:
    push dx ; Store DX on stack so later we can recall
    ; how many sectors were request to be read,
    ; even if it is altered in the meantime
    mov ah, 0x02 ; BIOS read sector function
    mov al, dh ; Read DH sectors
    mov ch, 0x00 ; Select cylinder 0
    mov dh, 0x00 ; Select head 0
    mov cl, 0x02 ; Start reading from second sector (i.e. after the boot sector)
    int 0x13 ; BIOS interrupt
    jc disk_error ; Jump if error (i.e. carry flag set)
    pop dx ; Restore DX from the stack
    cmp dh, al ; if AL (sectors read) != DH (sectors expected)
    jne disk_error ; display error message
    ret

disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

DISK_ERROR_MSG db "Disk read error!", 0

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

print_hex:
    mov cx, dx
    and cx, 0xf
    cmp cx, 10
    jl less_ten
    cmp cx, 10
    jge great_ten
end:
    ret
less_ten:
    add cx, 30
    mov ax, cx
    mov ah, 0x0e
    int 0x10
    jmp end
great_ten:
    add cx, 55
    mov ax, cx
    mov ah, 0x0e
    int 0x10
    jmp end

; Global variables
BOOT_DRIVE: db 0

BOOT:
    db 'Karen is booting...', 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55

; We know that BIOS will load only the first 512-byte sector from the disk,
; so if we purposely add a few more sectors to our code by repeating some
; familiar numbers , we can prove to ourselfs that we actually loaded those
; additional two sectors from the disk we booted from.
times 256 dw 0xdada
times 256 dw 0xface