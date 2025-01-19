extern "C" {

void interrupt_handler(void){
    asm __volatile__("cli; hlt");
}

}
