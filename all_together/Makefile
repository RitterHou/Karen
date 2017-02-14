all: os-image

os-image: boot.bin kernel.bin
	cat boot.bin kernel.bin 100m.img > os-image
	rm -f *.o *.bin

# Build the kernel binary
# kernel.bin: kernel_entry.o kernel.o
kernel.bin: kernel_entry.o
	ld -o kernel.bin -m elf_i386 -Ttext 0x1000 $^ --oformat binary
# Build the kernel entry object file.
kernel_entry.o: kernel_entry.asm
	nasm $< -f elf -o $@
# Build the kernel object file
kernel.o: kernel.c
	gcc -ffreestanding -c $< -m32 -o $@

boot.bin:
	cd ./bootloader && nasm boot.asm -f bin -o $@ && mv $@ .. && cd ..

clean:
	rm *.o *.bin os-image
