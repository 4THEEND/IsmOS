extern "C" {

__attribute__((noreturn))
void interrupt_handler(void);

}

void interrupt_handler(){
    asm __volatile__("cli; hlt");
}
