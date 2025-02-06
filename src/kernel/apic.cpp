#pragma once

#include "vga.cpp"
#include "types.hpp"
#include "exceptions_handler.cpp"


bool check_apic(void){
    asm __volatile__(
        "movl $1, %eax;"
        "cpuid"
    );

    uint32 edx = 0;
    asm __volatile__("movl %%edx, %0" : "=r" (edx) : );
    return edx & (1 << 9) != 0;
}


void init_apic(void){
    if(!check_apic()){
        kernel_panic("APIC not supported !!!");
    }

    raw_print("APIC supported !!!", 0, 0);
    asm __volatile__("cli;hlt");
}