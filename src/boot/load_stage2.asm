[bits 16]

load_stage2_disk:

    pusha                       ; Save registers
    push dx

    mov ah, 0x02
    mov al, dh

    mov cl, 0x02
    mov ch, 0x00

    mov dh, 0x00

    int 0x13                   
    jb .end_f                   ; Verify if the fuction triggered the carry flag

    pop dx
    cmp al, dh
    
    je .end_s                   ; If the number of sectors read is different from the one expected return error

    .end_after:
        print_string error_after
        jmp disk_loop

    .end_f: 
        print_string error_reading
        jmp disk_loop

    .end_s:
        print_string succesful_reading
        popa
        ret


disk_loop:
    jmp $
        


error_reading db "Error while reading from disk", 0
error_after db "Error in the numbers of sectors read from the disk", 0
succesful_reading db "Stage2 successfully loaded", 0