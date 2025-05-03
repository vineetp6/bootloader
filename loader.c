/*
 * loader.c — Stage 2: simple “kernel” written in C
 * Gets loaded at physical address 0x0000:0x8000
 */

#define VIDEO_MEM   ((volatile unsigned char*)0xB8000)
#define SCREEN_COLS 80   // width of text mode

// Entry point: must match ENTRY(kmain) in linker.ld
void kmain(void) {
    const char *msg = "Hello from C bootloader!";

    // VGA text mode: each character cell = 2 bytes (char, attribute)
    for (int i = 0; msg[i] != '\0'; i++) {
        VIDEO_MEM[i*2]     = msg[i];   // ASCII character
        VIDEO_MEM[i*2 + 1] = 0x07;     // Color attribute: light gray on black
    }

    // Halt so we don’t fall off into random memory
    while (1) {
        __asm__ ("hlt");  // low-power halt until next interrupt
    }
}

