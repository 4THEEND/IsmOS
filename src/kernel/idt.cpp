#include "types.hpp"

#define IDT_LENGTH 256


typedef struct {
    uint16 offset1;
    uint16 segment_selector;
    uint8 ist;
    uint8 flags;
    uint16 offset2;
    uint32 offset3;
    uint32 reserved;
}__attribute__((packed)) idt_entry_t;


typedef struct {
    uint16 size;
    uint64 offset;
}__attribute__((packed)) idtr_t;


__attribute__((aligned(0x10)))
static idt_entry_t idt[IDT_LENGTH];
static idtr_t idtr;


extern uint64 isr_table[];

void fill_idt(void){
    for(int i = 0; i < IDT_LENGTH; i++){
        idt[i].offset1 = isr_table[i] & 0xFFFF;
        idt[i].segment_selector = 0x08;
        idt[i].ist = 0;
        idt[i].flags = 0b10001110;
        idt[i].offset2 = (isr_table[i] >> 16) & 0xFFFF;
        idt[i].offset3 = (isr_table[i] >> 32) & 0xFFFFFFFF;
        idt[i].reserved = 0;
    }
}

void init_idt(void){
    fill_idt();

    idtr.size = (uint16)(sizeof(idt_entry_t) * IDT_LENGTH - 1);
    idtr.offset = (uint64)&idt[0];

    asm __volatile__("lidt %0" : : "m"(idtr));
    asm __volatile__("sti");
}