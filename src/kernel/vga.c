#define VGA_COLUMNS_NUM 80
#define VGA_ROWS_NUM 25
#define VGA_MEMORY_ADRESS 0xB8000

#define ARRAY_SIZE(arr) ((int)sizeof(arr) / (int)sizeof((arr)[0]))


void clear(void){
    volatile char* vga_buf = (volatile char*)0xb8000;
    for (int i = 0; i < VGA_COLUMNS_NUM * VGA_ROWS_NUM * 2; i++){
        vga_buf[i * 2] = '\0';
        vga_buf[i * 2 + 1] = 0x00;
    }
}


void raw_print(void){
    
}