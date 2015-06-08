.section .init
.globl _start
_start:
    b main

.section .text

main:
    mov sp, #0x8000             @ The default load address 

    mov r0, #16
    mov r1, #1
    bl SetGpioFunction

    ptrn .req r4
    ldr ptrn, =pattern
    ldr ptrn, [ptrn]    
    index .req r5
    mov index, #0

    morseLoop$:
        mov r0, #16
        mov r1, #1
        lsl r1, index
        and r1, ptrn
        bl SetGpio

        @ To load 500000, you have to do 8 bits at time, because of ARMv6 limitations to 32-bit instructions
        mov r0, #0x0003d000
        orr r0, #0x00000090
        bl Timer

        add index, #1
        and index, #0b11111
        b morseLoop$



.section .data
.align 2            @ Ensures that address of the next line is a multiple of 2^(n = 2). Important since ldr works with 32-bit words
pattern:
    .int 0b11111111101010100010001000101010     @Arbitrary binary sequence to represent morse code, or blinking (S O S in this case)
