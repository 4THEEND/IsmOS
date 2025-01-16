#include "vga.c"


void kmain(void){
    clear(); 

    volatile char *vga_buf = (volatile char *)0xb8000;
	const char *msg = "ABCDEFG";
    
    //Doesn't work
    /*while( *msg != 0 )
    {
        *vga_buf++ = *msg++;
        *vga_buf++ = 0x07;
    }*/

    
    //Works
    *vga_buf = msg[0];
    *(vga_buf + 1) = 0x07;
    *(vga_buf + 2) = msg[1];
    *(vga_buf + 3) = 0x07;
    *(vga_buf + 4) = msg[2];
    *(vga_buf + 5) = 0x07;
    *(vga_buf + 6) = msg[3];
    *(vga_buf + 7) = 0x07;
    
}