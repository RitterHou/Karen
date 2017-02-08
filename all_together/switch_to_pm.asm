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

    ret
