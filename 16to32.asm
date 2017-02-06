[org 0x7c00]

mov bp, 0x9000 ; Set the stack.
mov sp, bp

lgdt [gdt_descriptor]

cli   ; disable inturrepts

; 打开地址线A20
; in al, 92h
; or al, 00000010b
; out 92h, al

; switch to 32bit protected mode
mov eax, cr0 ; To make the switch to protected mode, we set
or eax, 0x1 ; the first bit of CR0, a control register
mov cr0, eax ; Update the control register

; jmp CODE_SEG:init_pm

init_pm:
mov ax, DATA_SEG ; Now in PM, our old segments are meaningless ,
mov ds, ax ; so we point our segment registers to the
mov ss, ax ; data selector we defined in our GDT
mov es, ax
mov fs, ax
mov gs, ax
mov ebp, 0x90000 ; Update our stack position so it is right
mov esp, ebp ; at the top of the free space.
call BEGIN_PM 

BEGIN_PM:
mov ebx, STRING             ; addr of characters
mov edx, VIDEO_MEMORY       ; addr of visual memory
mov ah, WHITE_ON_BLACK

call print_string_pm
jmp $

print_string_pm:
mov al, [ebx]

cmp al, 0
je done

mov [edx], ax

add ebx, 1
add edx, 2
jmp print_string_pm

done:
ret

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

STRING db 'We are in protected mode!', 0

; GDT
gdt_start:
gdt_null: ; the mandatory null descriptor
dd 0x0 ; ’dd’ means define double word (i.e. 4 bytes)
dd 0x0
gdt_code: ; the code segment descriptor
; base=0x0, limit=0xfffff ,
; 1st flags: (present)1 (privilege)00 (descriptor type)1 -> 1001b
; type flags: (code)1 (conforming)0 (readable)1 (accessed)0 -> 1010b
; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 1100b
dw 0xffff ; Limit (bits 0-15)
dw 0x0 ; Base (bits 0-15)
db 0x0 ; Base (bits 16-23)
db 10011010b ; 1st flags , type flags
db 11001111b ; 2nd flags , Limit (bits 16-19)
db 0x0 ; Base (bits 24-31)
gdt_data: ;the data segment descriptor
; Same as code segment except for the type flags:
; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
dw 0xffff ; Limit (bits 0-15)
dw 0x0 ; Base (bits 0-15)
db 0x0 ; Base (bits 16-23)
db 10010010b ; 1st flags , type flags
db 11001111b ; 2nd flags , Limit (bits 16-19)
db 0x0 ; Base (bits 24-31)
gdt_end: ; The reason for putting a label at the end of the
; GDT is so we can have the assembler calculate
; the size of the GDT for the GDT decriptor (below)
; GDT descriptior
gdt_descriptor:
dw gdt_end - gdt_start - 1 ; Size of our GDT, always less one
; of the true size
dd gdt_start ; Start address of our GDT
; Define some handy constants for the GDT segment descriptor offsets , which
; are what segment registers must contain when in protected mode. For example ,
; when we set DS = 0x10 in PM, the CPU knows that we mean it to use the
; segment described at offset 0x10 (i.e. 16 bytes) in our GDT, which in our
; case is the DATA segment (0x0 -> NULL; 0x08 -> CODE; 0x10 -> DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

times 510-($-$$) db 0   ; $ means current address, $$ means the start address, so 510-($-$$) means how many 0 we should write in this file after current address, then we can make this file is 510b. times x i means run i x times, so this instruction means we just run db 0(write a 0 here) 510-($-$$) times.
dw 0xaa55 
