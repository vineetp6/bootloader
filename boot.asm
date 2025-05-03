; ===================================================================
; boot.asm — Stage 1 boot sector (512 bytes total)
; Loads the second stage from disk into memory and jumps to it.
; ===================================================================

; Tell NASM: this code will be loaded by the BIOS at address 0x0000:0x7C00
[org 0x7C00]

start:
    cli                    ; Disable hardware interrupts while we set up
    xor ax, ax             ; Zero out AX register
    mov ds, ax             ; DS = 0
    mov es, ax             ; ES = 0

    ; ---------------------------------------------------------------
    ; Use BIOS interrupt 0x13 to read sector #2 (our loader) from disk
    ; ---------------------------------------------------------------
    mov ah, 0x02           ; AH=2 → disk read function
    mov al, 1              ; AL=1 → number of sectors to read
    mov ch, 0              ; CH=0 → cylinder 0
    mov cl, 2              ; CL=2 → sector 2 (sector 1 is this boot sector)
    mov dh, 0              ; DH=0 → head 0
    mov dl, [boot_drive]   ; DL = BIOS drive number (floppy=0x00, HDD=0x80)
    mov bx, 0x8000         ; BX=0x8000 → offset to load at
    mov es, bx             ; ES = segment 0x0000, so ES:BX = 0x0000:0x8000
    xor bx, bx             ; BX = 0
    int 0x13               ; BIOS disk read
    jc disk_error          ; if carry flag set → error

    sti                    ; Re-enable hardware interrupts

    ; ---------------------------------------------------------------
    ; Set up a simple stack
    ; ---------------------------------------------------------------
    mov ax, 0x0000
    mov ss, ax             ; Stack segment = 0
    mov sp, 0x7C00         ; Stack pointer just below our code

    ; Jump to the C loader at physical 0x0000:0x8000
    jmp 0x0000:0x8000

disk_error:
    cli                    ; On error, disable interrupts
.hang:
    hlt                    ; Halt CPU
    jmp .hang              ; Infinite loop

; ---------------------------------------------------------------
; BIOS signature and padding
; BIOS requires last two bytes of sector to be 0x55AA
; ---------------------------------------------------------------
times 510-($-$$) db 0     ; pad with zeros up to byte 510
dw 0xAA55                 ; 0xAA55 boot signature

; ---------------------------------------------------------------
; One-byte storage to remember which drive BIOS loaded us from
; BIOS puts drive number into DL before jumping to us
; ---------------------------------------------------------------
boot_drive: db 0

