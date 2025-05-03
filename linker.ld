/*
 * linker.ld — tells the linker where to place our code in memory
 */

ENTRY(kmain)      /* Start execution at the C function kmain */

SECTIONS
{
  /* Set the origin (.) to 0x8000, matching our Stage 1 jump */
  . = 0x8000;

  .text    : { *(.text) }    /* code */
  .rodata  : { *(.rodata) }  /* read-only data */
  .data    : { *(.data) }    /* initialized data */
  .bss     : { *(.bss COMMON) } /* zero-initialized data */
}

