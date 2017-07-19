# Synopsis
Simplest kernel possible created in C Language.
The kernel is in 32-bit protected mode and is made to be booted in a x86 CPU (i use Qemu Emulator, as an alternative you can use Bochs).

#Running
Requierements:
* [x86 CrossCompiler](http://wiki.osdev.org/GCC_Cross-Compiler)
'''
export PREFIX="/usr/local/i386elfgcc"
export TARGET=i386-elf
export PATH="$PREFIX/bin:$PATH"
'''
* [Qemu](http://www.qemu.org/)

