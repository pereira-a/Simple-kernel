; A boot sector that boots a C kernel in 32-bit protected mode
[org 0x7c00]
KERNEL_OFFSET equ 0x1000 ; Memory offset of Kernel

  ; BIOS stores the boot drive in dl
  mov [BOOT_DRIVE], dl

  ; Set up the stack
  mov bp, 0x9000
  mov sp, bp

  mov bx, MSG_REAL_MODE
  call print
  call print_nl

  call load_kernel  ; Loads the kernel

  call switch_to_pm ; Switch to protected mode

  jmp $ ; Never executed


%include "boot/16bit_print.asm"
%include "boot/16bit_print_hex.asm"
%include "boot/32bit_print.asm"
%include "boot/disk_load.asm"
%include "boot/gdt.asm"
%include "boot/switch_to_pm.asm"

[bits 16]
load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call print
  call print_nl

  ; Set up parameters to load the kernel
  mov bx, KERNEL_OFFSET ; (ES:BX) -> BX is the offset of the buffer adress pointer
  mov dh, 15            ; Load the first 15 sectors (excluding the boot sector)
  mov dl, [BOOT_DRIVE]
  call disk_load
  ret

[bits 32]
; Here is where it arrives after switching to PM
BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm

  call KERNEL_OFFSET ; Jump to the address of the loaded kernel code

  jmp $ ; hang

; Global variables
BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE   db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory"

times 510-($-$$) db 0
dw 0xaa55
