.globl FlashLed
FlashLed:
	push {lr}

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

    pinNum .req r0
    pinVal .req r1
    mov pinNum, #16
    mov pinVal, #1
    bl SetGpio
    .unreq pinNum
    .unreq pinVal

    delay .req r0
    mov delay, #0x0007a000
    orr delay, #0x00000120
    .unreq delay
    bl Timer

    pop {pc}

.globl TurnOnLed
TurnOnLed:
	push {lr}

    pinNum .req r0
    pinVal .req r1
    mov pinNum, #16
    mov pinVal, #0
    bl SetGpio
    .unreq pinNum
    .unreq pinVal

    pop {pc}

