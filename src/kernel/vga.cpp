#define VGA_COLUMNS_NUM 80
#define VGA_ROWS_NUM 25
#define VGA_MEMORY_ADRESS 0xB8000


enum vga_color {
    BLACK,
    BLUE,
    GREEN,         
    CYAN,
    RED,
    PURPLE,
    BROWN,
    GRAY,
    DARK_GRAY,
    LIGHT_BLUE,
    LIGHT_GREEN,
    LIGHT_CYAN,
    LIGHT_RED,
    LIGHT_PURPLE,
    YELLOW,
    WHITE
};



void clear_screen(void){
    volatile char* vga_buf = (volatile char*)VGA_MEMORY_ADRESS;
    for (int i = 0; i < VGA_COLUMNS_NUM * VGA_ROWS_NUM * 2; i++){
        vga_buf[i * 2] = '\0';
        vga_buf[i * 2 + 1] = 0x00;
    }
}


void raw_print_character(char character, int x, int y, vga_color text_color = WHITE, vga_color font_color = BLACK){
        volatile char* vga_buf = (volatile char*)VGA_MEMORY_ADRESS;

        vga_buf[2 * (y * VGA_COLUMNS_NUM + x) ] = character;
        vga_buf[2 * (y * VGA_COLUMNS_NUM + x) + 1] = (font_color << 4 | text_color); // first 4 bits is the foreground color
}


void scroll(int n = 1){

}


void raw_print(const char msg[], int x, int y, vga_color text_color = WHITE, vga_color font_color = BLACK){
    // verify if it does not overflow memory scroll if it's the case

    for(int i = 0; msg[i] != 0; i++){
        raw_print_character(msg[i], x + i, y, text_color, font_color);
    }
}


