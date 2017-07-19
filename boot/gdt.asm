; GDT Configuration: basic flat model
; GDT size (limit) : 16 bits
; GDT address (base) : 32 bits
gdt_start:
  ; the GDT starts with a null descriptor (8 bytes)
  dd 0x0
  dd 0x0

; GDT for code segment. base=0x0, limit=0xffffff
; 1st flags : ( present )1 ( privilege )00 ( descriptor type )1 -> 1001 b
; type flags : ( code )1 ( conforming )0 ( readable )1 ( accessed )0 -> 1010 b
; 2n d flags : ( granualarity )1 ( 32-bit default )1 ( 64-bit code segment )0 (AVL)0 -> 1100b
gdt_code:
  dw 0xffff     ; Limit (bits 0-15)
  dw 0x0        ; Base (bits 0-15)
  db 0x0        ; Base (bits 16-23)
  db 10011010b  ; 1st flags, type flags
  db 11001111b  ; 2nd flags, Limit (bits 16-19)
  db 0x0        ; Base (bits 24-31)

; GDT for data segment.
; Same as code segment, except in type flags
; type flags : ( code )0 ( expand down )0 ( writable )1 (accessed)0 -> 0010b
gdt_data:
  dw 0xffff     ; Limit (bits 0-15)
  dw 0x0        ; Base (bits 0-15)
  db 0x0        ; Base (bits 16-23)
  db 10010010b  ; 1st flags, type flags
  db 11001111b  ; 2nd flags, Limit (bits 16-19)
  db 0x0        ; Base (bits 24-31)

; So we can have the assembler calculate de size of the GDT
; for the GDT descriptor (below)
gdt_end:

; GDT descriptor
gdt_descriptor:
  dw gdt_end - gdt_start - 1 ; size (16 bit), always one less of its true size

  dd gdt_start ; adress(32 bits)

; Some constants for later use
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
