#include "vga.cpp"

extern "C" {

void kmain(void){
    clear_screen(); 

    raw_print("coucou", 1, 1, GREEN, BLACK);
    scroll();
    raw_print("salut", 1, 3);
    
}

}