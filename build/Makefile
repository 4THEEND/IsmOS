OS_NAME = IsmOS
SRC     = ../src
BOOT    = $(SRC)/boot
KERNEL  = $(SRC)/kernel

LINK_FILE = linker.ld

ASM  = nasm
QEMU = qemu-system-x86_64
CC   = x86_64-elf-gcc
CPP  = x86_64-elf-g++

LDFLAGS = -nostdlib -lgcc -mno-red-zone
CCFLAGS = -ffreestanding -g -mno-red-zone -mno-mmx -mno-sse -mno-sse2

BOOT_BINS   = boot.bin stage2.bin
KERNEL_OBJS = start.o kernel.o

all : $(OS_NAME).bin

%.bin : $(BOOT)/%.asm
	$(ASM) -i $(BOOT) -f bin $< -o $@

start.o : $(KERNEL)/start.asm
	$(ASM) -f elf64 $< -o $@

kernel.o : $(KERNEL)/kernel.cpp
	$(CPP) $(CCFLAGS) -c $< -o $@

kernel.bin	: $(KERNEL_OBJS)
	$(CC) -T $(LINK_FILE) -o $@ -ffreestanding $^ $(LDFLAGS)

$(OS_NAME).bin : $(BOOT_BINS) kernel.bin
	cat $^ > $@

.PHONY : clear run

run : $(OS_NAME).bin 
	$(QEMU) -no-reboot -d in_asm -drive  file=$<,index=0,if=floppy,format=raw


run-debug : $(OS_NAME).bin
	$(QEMU) -s -S -drive  file=$<,index=0,if=floppy,format=raw

clear :
	rm -f *.bin *.o