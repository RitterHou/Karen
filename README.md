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
