#pragma once

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
        vga_buf[2 * i] = '\0';
        vga_buf[2 * i + 1] = 0x00;
    }
}


void raw_print_character(const char character, int x, int y, vga_color text_color = WHITE, vga_color font_color = BLACK){
    volatile char* vga_buf = (volatile char*)VGA_MEMORY_ADRESS;

    vga_buf[2 * (y * VGA_COLUMNS_NUM + x) ] = character;
    vga_buf[2 * (y * VGA_COLUMNS_NUM + x) + 1] = (font_color << 4 | text_color); // first 4 bits is the foreground color
}


void scroll(int n = 1){
    volatile char* vga_buf = (volatile char*)VGA_MEMORY_ADRESS;

    for(int i = 0; i < 2 * VGA_COLUMNS_NUM * (VGA_ROWS_NUM - n); i++){
        vga_buf[2 * i] = vga_buf[(i + n * VGA_COLUMNS_NUM) * 2];
        vga_buf[2 * i + 1] = vga_buf[(i + n * VGA_COLUMNS_NUM) * 2 + 1];
    }

    for(int i = 2 * (VGA_COLUMNS_NUM * VGA_ROWS_NUM - VGA_COLUMNS_NUM * n); i < VGA_COLUMNS_NUM * VGA_ROWS_NUM * 2; i++){
        vga_buf[2 * i] = '\0';
        vga_buf[2 * i + 1] = 0x00;
    }
}


void raw_print(const char msg[], int x, int y, vga_color text_color = WHITE, vga_color font_color = BLACK){
    for(int i = 0; msg[i] != 0; i++){
        if(x > VGA_COLUMNS_NUM - 1){
            x = 0;
            y++;
        }
        if(y > VGA_ROWS_NUM - 1){
            scroll(y - VGA_ROWS_NUM + 1);
            y = VGA_ROWS_NUM - 1;
        }
        
        raw_print_character(msg[i], x, y, text_color, font_color);
        x++;
    }
}


