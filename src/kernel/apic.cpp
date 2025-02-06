#pragma once

#include "vga.cpp"
#include "types.hpp"


bool check_apic(void){
    asm __volatile__("movl $1, %eax");
    asm __volatile__("cpuid");

    uint32 edx = 0;
    asm __volatile__("movl %%edx, %0" : "=r" (edx) : );
    return edx & (1 << 9) != 0;
}


void init_apic(void){
    if(!check_apic()){
        raw_print("APIC not supported !!!", 0, 0, WHITE, RED);
        asm __volatile__("cli;hlt");
    }

    raw_print("APIC supported !!!", 0, 0);
    asm __volatile__("cli;hlt");
}