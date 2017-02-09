disk_load:
    ; mov bx, 0x9000  ; 把磁盘指定扇区中的数据加载内存中的 0x0000(ES):0x9000(BX) 处
    mov ah, 0x02    ; BIOS 读取扇区的方法
    ; mov al, 2       ; 读取 2 个扇区
    mov ch, 0x00    ; CHS 中的 cylinder 为 0
    mov dh, 0x00    ; CHS 中的 head 为 0
    mov cl, 0x02    ; 从第 2 个扇区开始读（即接在 bootsect 后面的扇区）
    int 0x13        ; 使用 BIOS 13 号中断开始从磁盘读数据到内存
    jc disk_error1  ; 中断调用时会设置 carry flag，如果未设置，则发生了错误
    mov bl, 2
    cmp bl, al      ; BIOS 在读取时会把真正读取到的扇区数赋给 al
    jne disk_error2 ; 如果 al 不为 2，则说明读取发生了错误
    ret

disk_error1:
    mov bx, DISK_ERROR_MSG1
    call print_string
    jmp $

disk_error2:
    mov bx, DISK_ERROR_MSG2
    call print_string
    jmp $

DISK_ERROR_MSG1  db 'DISK_ERROR_MSG1', 0
DISK_ERROR_MSG2  db 'DISK_ERROR_MSG2', 0
