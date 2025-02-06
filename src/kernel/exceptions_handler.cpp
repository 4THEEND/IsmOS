#include "vga.cpp"

extern "C" {

void exception_handler(uint32 error_code){
    asm __volatile__("cli; hlt");
}

void kernel_panic(const char msg[]){
    raw_print(msg, 0, 0, WHITE, RED);
    asm __volatile__("cli; hlt");
}

void kernel_warning(const char msg[]){
    raw_print(msg, 0, 0, WHITE, YELLOW);
}

}
