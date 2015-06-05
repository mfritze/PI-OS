.section .init
.globl _start
_start:
    b main

.section .text

main:
    mov sp, #0x8000             @ The default load address 

    pinNum .req r0
    pinFunc .req r1
    mov pinNum, #16
    mov pinFunc, #1
    bl SetGpioFunction
    .unreq pinNum
    .unreq pinFunc

    turnOn$:
        pinNum .req r0
        pinVal .req r1
        mov pinNum, #16
        mov pinVal, #0
        bl SetGpio
        .unreq pinNum
        .unreq pinVal

    @ To load 500000, you have to do 8 bits at time, because of ARMv6 limitations to 32-bit instructions
    delay .req r0
    mov delay, #0x0007a000
    orr delay, #0x00000120
    .unreq delay
    bl Timer

    @timerSum .req r2
    @mov timerSum, #0x3F0000
    @wait1$:
    @    sub timerSum, #1
    @    cmp timerSum, #0
    @    bne wait1$
    @.unreq timerSum

    turnOff$:
        pinNum .req r0
        pinVal .req r1
        mov pinNum, #16
        mov pinVal, #1
        bl SetGpio
        .unreq pinNum
        .unreq pinVal

    @ timerSum .req r2
	@ mov timerSum, #0x3F0000
	@ wait2$:
	@	sub timerSum, #1
	@	cmp timerSum, #0
	@	bne wait2$
    @.unreq timerSum

    delay .req r0
    mov delay, #0x0007a000
    orr delay, #0x00000120
    .unreq delay
    bl Timer

    b turnOn$

