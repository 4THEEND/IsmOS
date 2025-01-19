#include "types.hpp"

#define IDT_LENGTH 256


typedef struct {
    uint16 offset1;
    uint16 segment_selector;
    uint16 ist;
    uint16 offset2;
    uint32 offset3;
    uint32 reserved;
}__attribute__((packed)) idt_entry_t;


typedef struct {
    uint16 size;
    uint32 offset;
}__attribute__((packed)) idtr_t;


__attribute__((aligned(0x10)))
static idt_entry_t idt[IDT_LENGTH];
static idtr_t idtr;


void fill_idt(void){
    for(int i = 0; i < IDT_LENGTH; i++){
        idt[i].offset1 = 0;
        idt[i].segment_selector = 0;
        idt[i].ist = 0;
        idt[i].offset2 = 0;
        idt[i].offset3 = 0;
        idt[i].reserved = 0;
    }
}

extern void* isr_table[32];

void init_idt(void){
    fill_idt();

    idtr.offset = 0;
    idtr.size = sizeof(idt);

    //asm __volatile__("lidt");
    //asm __volatile__("sti");
}