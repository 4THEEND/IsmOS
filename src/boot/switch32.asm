[bits 16]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; A20 Line ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

enable_a20:
    mov ax, 0x2403  ; magic string :)
    int 0x15
    jb .a20_int15_not_supported

    mov ax, 0x2402  ; another magic string :)
    int 0x15
    jb .a20_fail

    cmp ah, 0
    jnz .a20_not_stat
    cmp al, 1
    jz .a20_already_enabled

    mov ax, 0x2401
    int 0x15
    jb .a20_fail

    cmp ah, 0
    jnz .a20_fail
    cmp al, 1
    jnz .a20_fail


    .a20_already_enabled:
        print_string a20_already_enabled_m
        jmp end_s
    .a20_enabled:
        print_string a20_enabled_m
        jmp end_s
    .a20_fail:
        print_string a20_fail_m
        jmp end_f
    .a20_not_stat:
        print_string a20_not_stat_m
        jmp end_f
    .a20_int15_not_supported:
        print_string a20_already_enabled_m
        jmp end_f


    end_f: 
        jmp $
    end_s:
        ret


a20_not_stat_m db "Cannot get A20 line's status", 0
a20_int15_not_supported_m db "Instruction 15h is not supported by the bootloader"
a20_already_enabled_m db "A20 line already enabled", 0
a20_enabled_m db "A20 line enabled sucessfully", 0
a20_fail_m db "Failed to enable A20 line via BIOS functions", 0



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GDT32 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

null_sgt:
    dq 0x0            ; 8 null bytes
code_sgt_gdt:
    dw 0xffff       ; limit adress
    dw 0x0000       ; base adress
    db 0x00         ; base adress 2
    db 10011010b    ; acess byte (remember the privilege level is on 2 bits)
    db 11001111b    ; flags
    db 0x0          ; base 3
data_sgt_gdt:
    dw 0xffff       ; limit adress
    dw 0x0000       ; base adress
    db 0x00         ; base adress 2
    db 10010010b    ; acess byte
    db 11001111b    ; flags
    db 0x0          ; base 3
end_gdt:

GDT_DESCRIPTOR:
    dw end_gdt - null_sgt - 1
    dd null_sgt


CODE_SGT equ (code_sgt_gdt - null_sgt)
DATA_SGT equ (data_sgt_gdt - null_sgt)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SWITCH 32 bits ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

switch_32_bits:
    call enable_a20

    cli

    lgdt [GDT_DESCRIPTOR]

    mov eax, cr0
    or al, 1
    mov cr0, eax

    jmp CODE_SGT:init_32


[bits 32]
init_32:
    mov ax, DATA_SGT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x7c00
    mov esp, ebp

    call switch_long_mode

    jmp $
