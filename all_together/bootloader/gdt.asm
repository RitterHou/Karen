; ******** GDT 开始的标记 ********
gdt_start:
; GDT 的第一项必须为 0
gdt_null:
    dd 0x0      ; dd，4 个字节
    dd 0x0
; 代码段描述符，一段很机械的的定义，参考 Intel 手册即可
gdt_code:
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
; 数据段描述符，一段很机械的的定义，参考 Intel 手册即可
gdt_data:
    ; Same as code segment except for the type flags:
    ; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
    dw 0xffff ; Limit (bits 0-15)
    dw 0x0 ; Base (bits 0-15)
    db 0x0 ; Base (bits 16-23)
    db 10010010b ; 1st flags , type flags
    db 11001111b ; 2nd flags , Limit (bits 16-19)
    db 0x0 ; Base (bits 24-31)
; 在这里放置一个标记方便我们计算 gdt 的长度
gdt_end:

; GDT descriptior
gdt_descriptor:
dw gdt_end - gdt_start - 1 ; Size of our GDT, always less one of the true size
dd gdt_start ; Start address of our GDT

; 把描述符的位置通过常量的值保存下来
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start