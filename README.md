# karenn
The software which we need is 
* nasm
* qemu

Assemble instruction is
```sh
nasm print_string.asm -f bin -o print_string.bin
```
The option `-f bin` is telling the assemble to produce raw machine code.

Then we will have a runnable file named `print_string.bin`,we can run this OS by
```sh
qemu-system-i386 print_string.bin
```

Switch from 16bit real mode to 32 protect mode:
1. define a GDT and it will be loaded into memory;
2. using `cli` to disable interrupts;
3. using instruction `lgdt` then we can save the address of GDT into gdtr;
4. change the first bit of `CR0` to 1, now we are in 32bit protected mode;

