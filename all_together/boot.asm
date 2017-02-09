[org 0x7c00]

mov bx, BOOTING_MSG
call print_string

call load_kernel

call switch_to_pm

%include "print_string.asm"
%include "disk_load.asm"
%include "switch_to_pm.asm"
%include "gdt.asm"

load_kernel:
    mov bx, LOADING_KERNEL
    call print_string

    mov bx, KERNEL_OFFSET
    mov al, 2
    ; mov dl, [BOOT_DRIVE]
    call disk_load

    ret

BEGIN_PM:
    mov edx, VIDEO_MEMORY       ; 显存的初始地址
    mov ax, 0
    call clear_screen

    mov ebx, STRING_PM          ; 被打印字符的地址
    mov edx, VIDEO_MEMORY       ; 显存的初始地址
    mov ah, WHITE_ON_BLACK      ; 设置文字的颜色
    call print_string_pm

    call KERNEL_OFFSET

    jmp $


BOOTING_MSG     db 'Karen is booting...', 0x0a, 0x0d, 0
LOADING_KERNEL  db 'Loading kernel...', 0x0a, 0x0d, 0

BOOT_DRIVE      db 0

KERNEL_OFFSET   equ 0x1000

times 510-($-$$) db 0
dw 0xaa55
