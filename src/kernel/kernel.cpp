#include "vga.cpp"
#include "idt.cpp"
#include "apic.cpp"

extern "C" {

void kmain(void){
    init_idt();
    init_apic();

    clear_screen(); 

    raw_print("coucou", 1, 2, GREEN, BLACK);
    scroll();
    raw_print("salut", 1, 3);

    raw_print("coucou les kheys", 75, 24);
}

}