[bits 32]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GDT64 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

null_sgt_64:
    dq 0x0            ; 8 null bytes
code_sgt_gdt_64:
    dw 0xffff       ; limit adress
    dw 0x0000       ; base adress
    db 0x00         ; base adress 2
    db 10011010b    ; acess byte (remember the privilege level is on 2 bits)
    db 10101111b    ; flags
    db 0x0          ; base 3
data_sgt_gdt_64:
    dw 0xffff       ; limit adress
    dw 0x0000       ; base adress
    db 0x00         ; base adress 2
    db 10010010b    ; acess byte
    db 10101111b    ; flags
    db 0x0          ; base 3
end_gdt_64:

GDT_DESCRIPTOR_64:
    dw end_gdt_64 - null_sgt_64 - 1
    dq null_sgt_64


CODE_SGT_64 equ (code_sgt_gdt_64 - null_sgt_64)
DATA_SGT_64 equ (data_sgt_gdt_64 - null_sgt_64)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PAGING ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


build_page_table:
    pusha

    PAGE64_PAGE_SIZE equ 0x1000
    PAGE64_TAB_SIZE equ 0x1000
    PAGE64_TAB_ENT_NUM equ 512

    mov ecx, PAGE64_TAB_SIZE ; ecx stores the number of repetitions
    mov edi, ebx             ; edi stores the base address
    xor eax, eax             ; eax stores the value
    rep stosd

    ;; Link first entry in PML4 table to the PDP table
    mov edi, ebx
    lea eax, [edi + (PAGE64_TAB_SIZE | 11b)] ; Set read/write and present flags
    mov dword [edi], eax

    ;; Link first entry in PDP table to the PD table
    add edi, PAGE64_TAB_SIZE
    add eax, PAGE64_TAB_SIZE
    mov dword [edi], eax

    ;; Link the first entry in the PD table to the page table
    add edi, PAGE64_TAB_SIZE
    add eax, PAGE64_TAB_SIZE
    mov dword [edi], eax

    ;; Initialize only a single page on the lowest (page table) layer in
    ;; the four level page table.
    add edi, PAGE64_TAB_SIZE
    mov ebx, 11b
    mov ecx, PAGE64_TAB_ENT_NUM
.set_page_table_entry:
    mov dword [edi], ebx
    add ebx, PAGE64_PAGE_SIZE
    add edi, 8
    loop .set_page_table_entry

    popa
    ret




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRINTING 32 bits ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_string32:
    pusha

    VGA_BUF equ 0xb8000
    WB_COLOR equ 0xf

    mov edx, VGA_BUF

print_string32_loop:
    cmp byte [ebx], 0
    je print_string32_return

    mov al, [ebx]
    mov ah, WB_COLOR
    mov [edx], ax

    add ebx, 1              ; Next character
    add edx, 2              ; Next VGA buffer cell
    jmp print_string32_loop

print_string32_return:
    popa
    ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PRINTING 64 bits ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_string64:

    VGA_BUF equ 0xb8000
    WB_COLOR equ 0xf

    mov edx, VGA_BUF

print_string64_loop:
    cmp byte [ebx], 0
    je print_string64_return

    mov al, [ebx]
    mov ah, WB_COLOR
    mov [edx], ax

    add ebx, 1              ; Next character
    add edx, 2              ; Next VGA buffer cell
    jmp print_string64_loop

print_string64_return:
    ret





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SWITCH 64 bits ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_cpuid:
    pushfd
    
    pop eax
    mov ecx, eax        ; store the value for further comp

    xor eax, (1 << 21)  ; flip 21th bit
    push eax

    popfd

    pushfd
    pop eax

    push ecx
    popfd               ; set it back to normal in case the bit really has been shifted

    xor eax, ecx
    jz cpuid_not_supported

    mov ebx, cpuid_supported_msg
    call print_string32 

    call check_long_mode_func

    jmp $


cpuid_not_supported:
    mov ebx, cpuid_not_supported_msg
    call print_string32 

    jmp $



check_long_mode_func:
    mov eax, 0x80000000
    cpuid

    cmp eax, 0x80000001

    jb long_mode_not_supported ; jump is eax > 0x80000001
    
    mov ebx, long_mode_supported_msg
    call print_string32 

    call check_long_mode

    jmp $


check_long_mode:
    mov eax, 0x80000001
    cpuid
    test edx, (1 << 29) ; long mode aviability is stored at bit 29 of edx after the cpuid call

    jz long_mode_not_supported

    mov ebx, 0x1000
    call build_page_table
    mov cr3, ebx

    ; enable PAE by flipping the 5th bit in cr4
    mov edx, cr4        
    or edx, (1 << 5)
    mov cr4, edx   


    ; enable compatibility long mode
    mov ecx, 0xC0000080 ; EFER MSR
    rdmsr
    or eax, (1 << 8)    ; Long Mode Enable is the 8th bit of model specific registers (bit 10 long mode active)
    wrmsr

    ; Enabling paging
    mov eax, cr0                 
    or eax, (1 << 31)
    mov cr0, eax      

    mov ebx, long_mode_supported_msg
    call print_string32 

    call load_gdt

long_mode_not_supported:
    mov ebx, long_mode_not_supported_msg
    call print_string32 

    jmp $

load_gdt:
    cli
    lgdt [GDT_DESCRIPTOR]

    jmp CODE_SGT_64:kernel_go_brrrr


cpuid_not_supported_msg db "CPUID  not supported by this CPU", 0
cpuid_supported_msg db "CPUID supported by this CPU", 0
long_mode_supported_msg db "Long mode supported by this CPU", 0
long_mode_not_supported_msg db "Long mode not supported by this CPU", 0
sucess_enter_compatibility db "Sucessfully entered 64 bit mode", 0

