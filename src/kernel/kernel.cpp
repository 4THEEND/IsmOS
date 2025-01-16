#include "vga.cpp"

extern "C" {

void kmain(void){
    clear(); 

    raw_print("coucou", 1, 1, GREEN, BLACK);
    raw_print("salut", 1, 2);
    
}

}