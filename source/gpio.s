.globl GetGpioAddress
GetGpioAddress:                 @ Returns the address of the GPIO pins
    gpioAddr .req r0
    ldr gpioAddr, =0x20200000
    mov pc,lr
    .unreq gpioAddr

.globl SetGpioFunction
SetGpioFunction:
    pinNum .req r0
    pinFunc .req r1
	cmp   pinNum, #53                   @ There are only 54 pins
    cmpls pinFunc, #7                   @ There are only 8 functions per pin
    movhi pc, lr                        @ In ARM, you can attach the conditional suffixes to commands st they only
                                        @ execute when they satisfy the cmp operation. Like ls and hi here

    push {lr}                           @ Put the Link Register on the stack, move the value of the pin over to r2
    mov r2, pinNum                      @ Then get the GPIO address in r0.
    .unreq pinNum
    pinNum .req r2
    bl GetGpioAddress
    gpioAddr .req r0

    fucntionLoop$:                      @ Add 4*x to the GPIO offset, x = PIN NUMBER % 10
        cmp pinNum, #9
        subhi pinNum, #10
        addhi gpioAddr, #4
        bhi   fucntionLoop$

    add pinNum, pinNum, lsl #1          @ Same as r2 = r2 * 3. shifts r2 by 1 (*2) before use
    lsl pinFunc, pinNum                 @ remember, 3 bits per pin

    mask .req r3
    mov mask,  #111                   @ r3 is the mask 
    lsl mask, pinNum                      
    mvn mask, mask
    oldFunc .req r4
    ldr oldFunc, [gpioAddr]
    and oldFunc, mask          @ Zeroes out old fuction bits
    orr pinFunc, oldFunc       @ Adds new function bits

    str pinFunc, [gpioAddr]
    .unreq gpioAddr
    .unreq pinFunc
    .unreq pinNum
    .unreq mask
    .unreq oldFunc

    pop {pc}


.globl SetGpio
SetGpio:
    pinNum .req r0                  @ Create a register alias
    pinVal .req r1

    cmp pinNum, #53
    movhi pc, lr
    push {lr}
    mov r2, pinNum
    .unreq pinNum
    pinNum .req r2
    bl GetGpioAddress
    gpioAddr .req r0

    pinBank .req r3
    lsr pinBank, pinNum, #5         @ Divide by 32
    lsl pinBank, #2                 @ Multiply by 4 (pinBank is either 1 or 0, depending on if the pin is above 32 (second set of 4 bytes))
    add gpioAddr, pinBank           @ gpioAddr is now 0x20200000 or 0x20200004
    .unreq pinBank                  

    and pinNum, #31                 @ Get the remainder of a division by 32
    setBit .req r3  
    mov setBit, #1              
    lsl setBit, pinNum              @ Put a 1 in to set the pinNum'th bit
    .unreq pinNum

    teq pinVal, #0
    .unreq pinVal
    streq setBit, [gpioAddr, #40]
    strne setBit, [gpioAddr, #28]
    .unreq setBit
    .unreq gpioAddr
    pop {pc}

