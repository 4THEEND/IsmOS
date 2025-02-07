[org 0x7c00]  ; origin at 0x7c00 (offset)

[bits 16]     ; BIOS start in 16 bits real mode

; |---------------------| <- 0x0000
; |BIOS reserved memory |
; |---------------------| <- 0x0050 ?
; |        Stack        |
; |                     |
; |---------------------| <- 0x7c00
; |                     |
; |      Bootloader     |   (512 bytes size)
; |                     |
; |---------------------| <- 0x7e00
; |                     |
; |        Stage2       |   (0x1200 bytes size)
; |                     |
; |---------------------| <- 0x9000 (before paging/ after identity paging)
; |                     |
; |        Kernel       |   
; |                     |
; |---------------------|
;
;   This construction is safer than putting than putting the stack after the bootloader because the stack
;   grows downward.
;   A new stack is reserved in start.asm and is 16 bytes aligned to call c code

STAGE2_OFFSET equ 0x7e00

xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7c00

mov ah, 0x0
mov al, 0x03

int 0x10

jb failed_video

mov [boot_drive], dl

jmp boot      ; start boot sequence


%macro print_string 1
    mov si, %1
    call real_mode_print
    mov si, newline
    call real_mode_print
%endmacro


%include "load_stage2.asm"  ; loading stage2 in memory before switching to protected mode bc it's easier to load with BIOS interrupts


[bits 16]   ; set again to 16 bits bc switch 64 changed it to 32

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


boot:
    cld                     ; clean flags for lodsb
    print_string boot_msg

    mov bx, STAGE2_OFFSET
    mov dh, 0x41
    mov dl, [boot_drive]

    call load_stage2_disk       ; load stage2 in memory before switching to protected/long mode

    call STAGE2_OFFSET

    jmp $


failed_video:
    print_string set_video_msg
    jmp $



boot_drive db 0
set_video_msg db "Failed to set video mode", 0
boot_msg db "Starting boot sequence !!!", 0
newline db 0x0D, 0x0A, 0

times 510 - ($ - $$) db 0
dw 0AA55h