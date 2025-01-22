extern "C" {

void exception_handler(void){
    asm __volatile__("cli; hlt");
}

}
