;To jump into 32-bit mode:
;
; 1. Disable interrupts
; 2. Load our GDT
; 3. Set a bit on the CPU control register cr0
; 4. Flush the CPU pipeline by issuing a carefully crafted far jump
; 5. Update all the segment registers
; 6. Update the stack
; 7. Call to a well-known label which contains the first useful code in 32 bits

[bits 16]
switch_to_pm:
  cli ; 1. disable interrupts
  lgdt [gdt_descriptor] ; 2. load the GDT descriptor
  mov eax, cr0
  or eax, 0x1 ; 3. set 32-bit mode bit in cr0
  mov cr0, eax
  jmp CODE_SEG:init_pm ; 4. far jump by using a different segment

[bits 32]
init_pm:
  ; 5. update all the segment registers (because now in 32 bits, they are meaningless)
  mov ax, DATA_SEG
  mov ds, ax
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  ; 6. update the stack positionm so it is right at the top of the free space
  mov ebp, 0x90000
  mov esp, ebp

  call BEGIN_PM ; 7. call some well-known label
