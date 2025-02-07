#include "vga.cpp"

extern "C" {

void exception_handler(){
    asm __volatile__("cli; hlt");
}

void kernel_panic(const char msg[]){
    raw_print(msg, 0, 0, WHITE, RED);
    asm __volatile__("cli; hlt");
}

void kernel_warning(const char msg[]){
    raw_print(msg, 0, 0, BLACK, YELLOW);
}

void kernel_info(const char msg[]){
    raw_print(msg, 0, 0);
}

}
