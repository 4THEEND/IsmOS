[org 0x7e00]    ; We know our second stage will be loaded just following the first
[bits 16]

%macro print_string 1
    mov si, %1
    call real_mode_print
    mov si, newline
    call real_mode_print
%endmacro

KERNEL_OFFSET equ 0x9000    ; Put the same value as in linker.ld and calc the size of stage2.bin to put it right after stage2


jmp stage2

%include "switch32.asm"     ; switch to 32 bits protected mode
%include "switch64.asm"     ; switch to 64 bits long mode from protected mode


[bits 16]
real_mode_print:
    jmp .fetch
    .print:
        mov ah, 0x0e
        int 0x10
    .fetch:
        lodsb           ; load from si and increment counter
        cmp al, 0       ; verify if al == 0
        jne .print
    ret

stage2:
    print_string stage2_m

    call switch_32_bits

    jmp $


[bits 32]
switch_long_mode:
    call check_cpuid
    jmp $


[bits 64]
kernel_go_brrrr:
    mov ax, DATA_SGT_64
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov ebx, sucess_enter_compatibility
    call print_string64
    
    call KERNEL_OFFSET
    jmp $



protected_mess db "Switch to protected mode done"
stage2_m db "Second boot sequence starting !!!", 0
newline db 0x0D, 0x0A, 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FILL ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

times 0x1200 - ($ - $$) db 0