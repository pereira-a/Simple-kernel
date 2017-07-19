# $@ = target file
# $< = first dependency
# $^ = all dependencies
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)
OBJ = $(C_SOURCES:.c=.o)

all: os-image.bin

run: os-image.bin
	qemu-system-x86_64 -fda $<

kernel.bin: kernel/kernel_entry.o ${OBJ}
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

# Generic rule for compiling C code to object file
%.o : %.c ${HEADERS}
	i386-elf-gcc -ffreestanding -c $< -o $@

# Generic rule for assembler
%.o : %.asm
	nasm -f elf $< -o $@

%.bin: %.asm
	nasm -f bin $< -o $@

# Disassemble the kernel (debug)
kernel.dis: kernel.bin
	ndisasm -b 32 $< > $@

os-image.bin: boot/boot_sect.bin kernel.bin
	cat $^ > $@

clean:
	rm -rf *.bin *.dis *.o os-image.bon *.elf
	rm -rf kernel/*.o boot/*.bin drivers/*.o boot/*.o
