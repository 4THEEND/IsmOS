#include "idt.cpp"
#include "pic.cpp"

extern "C" {

void kmain(void){
    clear_screen(); 

    init_idt();
    init_pic();

    raw_print("coucou", 1, 2, GREEN, BLACK);
    scroll();
    raw_print("salut", 1, 3);

    raw_print("coucou les kheys", 75, 24);
}

}