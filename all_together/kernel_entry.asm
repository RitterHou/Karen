; Ensures that we jump straight into the kernel’s entry function.
; [bits 32] ; We’re in protected mode by now, so use 32-bit instructions.
; [extern main] ; Declate that we will be referencing the external symbol ’main’,
; so the linker can substitute the final address

mov ebx, STRING_PM          ; 被打印字符的地址
mov edx, VIDEO_MEMORY       ; 显存的初始地址
mov ah, WHITE_ON_BLACK      ; 设置文字的颜色
call print_string_pm

; call main ; invoke main() in our C kernel
jmp $ ; Hang forever when we return from the kernel

print_string_pm:
    mov al, [ebx]
    cmp al, 0
    je done
    mov [edx], ax               ; al 为字符，ah 为颜色，修改显存对应位置的值即可显示字符

    add ebx, 1          ; 字符的位置加一
    add edx, 2          ; 显存的地址加二
    jmp print_string_pm

done:
    ret

STRING_PM       db 'sadsadsadasdasdd', 0
VIDEO_MEMORY    equ 0xb8000
WHITE_ON_BLACK  equ 0x0f