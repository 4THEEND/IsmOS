#include "vga.c"


void kmain(void){
    //clear(); 

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
	*(++vga_buf) = 0x07;

    *(++vga_buf) = msg[1];
	*(++vga_buf) = 0x07;

    *(++vga_buf) = msg[2];
	*(++vga_buf) = 0x07;
    
    
}