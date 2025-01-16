#include "vga.c"


void kmain(void){
    //clear(); 

    volatile char *vga_buf = (volatile char *)VGA_MEMORY_ADRESS;
	const char msg[] = "ABCDEFG";
    
    /*while( *msg != 0 )
    {
        *vga_buf++ = *msg++;
        *vga_buf++ = 0x07;
    }*/


    //*vga_buf = *msg;
    //*(++vga_buf) = 0x07;

    /*
    *(vga_buf + 2) = msg[1];
    *(vga_buf + 3) = 0x07;
    *(vga_buf + 4) = msg[2];
    *(vga_buf + 5) = 0x07;
    *(vga_buf + 6) = msg[3];
    *(vga_buf + 7) = 0x07;
    
    *(vga_buf + 8) = '\0';
    *(vga_buf + 9) = 0x07;*/
    
}