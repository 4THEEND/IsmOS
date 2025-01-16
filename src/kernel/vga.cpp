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



void clear(void){
    volatile char* vga_buf = (volatile char*)VGA_MEMORY_ADRESS;
    for (int i = 0; i < VGA_COLUMNS_NUM * VGA_ROWS_NUM * 2; i++){
        vga_buf[i * 2] = '\0';
        vga_buf[i * 2 + 1] = 0x00;
    }
}


void raw_print(const char msg[], int x, int y, enum vga_color text_color = WHITE, enum vga_color font_color = BLACK){
    volatile char* vga_buf = (volatile char*)VGA_MEMORY_ADRESS;

    for(int i = 0; msg[i] != 0; i++){
        vga_buf[2 * (i + y * VGA_COLUMNS_NUM + x) ] = msg[i];
        vga_buf[2 * (i + y * VGA_COLUMNS_NUM + x) + 1] = (font_color << 4 | text_color); // first 4 bits is the foreground color
    }
}