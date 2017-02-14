switch_to_pm:
    lgdt [gdt_descriptor]   ; 把 gdt 的位置保存到 gdtr 中

    cli                     ; 屏蔽中断

    ; 把 cr0 的最低位置为 1，开启 32 位保护模式
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

; jmp CODE_SEG:init_pm    ; 进行一次远跳转来刷新 CPU 缓存，存在问题

; 初始化段寄存器的值并设置栈的位置
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x90000    ; 现在栈顶指向 0x90000
    mov esp, ebp

    call BEGIN_PM


clear_screen:
    cmp ax, 1000
    je done
    mov bx, 0
    mov [edx], bx

    add ax, 1
    add edx, 2
    jmp clear_screen


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

STRING_PM       db 'We are in pm now...', 0
VIDEO_MEMORY    equ 0xb8000
WHITE_ON_BLACK  equ 0x0f
