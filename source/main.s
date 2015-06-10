.section .init
.globl _start
_start:
    b main

.section .text
main:
    mov sp, #0x8000             @ The default load address 

    mov r0, #1024
    mov r1, #768
    mov r2, #16
    bl InitializeFrameBuffer

    teq r0, #0
    bne gpuOK$

    bl TurnOnLed
    error$:
        b error$

    gpuOK$:
        frameBufferInfoAddr .req r4
        mov frameBufferInfoAddr, r0

    render$:
        fbAddr .req r3
        ldr fbAddr, [frameBufferInfoAddr, #32]

        colour .req r0
        y .req r1
        mov y, #768

        drawRow$:
            x .req r2
            mov x, #1024

            drawPixel$:
                strh colour, [fbAddr]
                add fbAddr, #2
                sub x, #1
                teq x, #0
                bne drawPixel$

            .unreq x
            sub y, #1
            add colour, #1
            teq y, #0
            bne drawRow$

        .unreq y
        .unreq fbAddr
        .unreq colour
        bl FlashLed
        b render$

    .unreq frameBufferInfoAddr

