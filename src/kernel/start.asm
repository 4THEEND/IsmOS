section .bss
    align 16
    stack_bottom : 
        resb 4096   ; register a 4096 bytes stack
    stack_top: 

section .text
    extern kmain
    global _start

 _start:

    mov rsp, stack_top

    ;call kmain  

    cli         ; clear interrupts 
    .halt :     ; enter infinite loop to block pc
        hlt
        jmp .halt
    .end: 