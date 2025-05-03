Bootloader Project

This project demonstrates a minimal two-stage x86 bootloader written in NASM assembly (Stage 1) and C (Stage 2), suitable for running under QEMU or on real hardware. It’s designed for beginners and runs on Ubuntu WSL and Windows 11.

📂 File Structure
bootloader/
├── Makefile       # Build instructions
├── linker.ld      # Linker script for placing the C code
├── boot.asm       # Stage 1: 512-byte boot sector (NASM)
├── loader.c       # Stage 2: C "kernel"
└── README.md      # This documentation


How It Works

boot.asm (Stage 1)

Loaded by the BIOS at 0x0000:0x7C00.

Uses BIOS interrupt 0x13 to read the next sector (our C loader) into memory at physical address 0x0000:0x8000.

Sets up a minimal stack and jumps to the C entry point at 0x0000:0x8000.

Contains the boot signature 0xAA55 at the end of the 512-byte sector.

loader.c (Stage 2)

Placed at linear address 0x8000 by the linker script (linker.ld).

Entry function kmain() writes a message to VGA text buffer at 0xB8000, displaying "Hello from C bootloader!".

Enters an infinite hlt loop to halt the CPU.

linker.ld

Directs the linker to place .text, .rodata, .data, and .bss at 0x8000.

Sets kmain as the entry point.

Makefile

Assembles boot.asm using NASM.

Compiles and links loader.c as a freestanding 32-bit binary (no libc).

Concatenates the boot sector and loader into a raw boot.bin image.

⚙️ Prerequisites

Ubuntu WSL on Windows 11, or any Debian/Ubuntu system.

QEMU for testing (optional).

Install dependencies:
sudo apt update
sudo apt install -y nasm gcc-multilib binutils qemu-system-x86

Building & Running on Ubuntu WSL

Clone the repository:
git clone  && cd bootloader
Run this command in bootloader folder : make
make with generates this : boot.bin (512-byte stage1 + stage2).

Run in QEMU on ubuntu wsl: qemu-system-x86_64 -drive format=raw,file=boot.bin
- You should see "Hello from C bootloader!" on the emulated screen.

4. **Clean** build artifacts:
   ```bash
make clean


Running on Windows 11 (CMD Prompt)

Install Ubuntu WSL and required packages:

wsl --install -d Ubuntu-20.04
wsl sudo apt update
wsl sudo apt install -y nasm gcc-multilib binutils qemu-system-x86

cd \\wsl.localhost\Ubuntu-22.04\home\vinit\bootloader,because bootloader folder is in home/vinit then open command prompt and run command below : 
wsl qemu-system-x86_64 -drive format=raw,file=boot.bin

Then run this in command prompt : wsl make clean


---

## 🔧 Extending the Bootloader

- Modify `loader.c` to add keyboard input, simple graphics, or disk access.
- Extend `boot.asm` to load more sectors or switch to protected mode.
- Explore writing your own minimal kernel routines.

---

## 📖 Further Reading

- [OSDev Wiki: Bootloader](https://wiki.osdev.org/Bootloader)
- [OSDev Wiki: Setting up a C Development Environment](https://wiki.osdev.org/GCC_Cross-Compiler)
