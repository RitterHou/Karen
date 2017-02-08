[org 0x7c00]

mov bx, BOOTING_MSG
call print_string

call load_kernel

call switch_to_pm

jmp $

%include "print_string.asm"
%include "disk_load.asm"
%include "gdt.asm"
%include "switch_to_pm.asm"

load_kernel:
    mov bx, LOADING_KERNEL
    call print_string

    mov bx, KERNEL_OFFSET
    mov al, 15
    ; mov dl, [BOOT_DRIVE]
    call disk_load

    ret

BOOTING_MSG     db 'Karen is booting...', 0x0a, 0x0d, 0
LOADING_KERNEL  db 'Loading kernel...', 0x0a, 0x0d, 0

BOOT_DRIVE      db 0

KERNEL_OFFSET   equ 0x1000

times 510-($-$$) db 0
dw 0xaa55
