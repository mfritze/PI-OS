.section .data
.align 12
.globl FrameBufferInfo
FrameBufferInfo:
	.int 1024 /* #0 Physical Width */
	.int 768 /* #4 Physical Height */
	.int 1024 /* #8 Virtual Width */
	.int 768 /* #12 Virtual Height */
	.int 0 /* #16 GPU - Pitch */
	.int 16 /* #20 Bit Depth */
	.int 0 /* #24 X */
	.int 0 /* #28 Y */
	.int 0 /* #32 GPU - Pointer */
	.int 0 /* #36 GPU - Size */


.section .text
.globl InitializeFrameBuffer
InitializeFrameBuffer:
	width .req r0
	height .req r1
	bitdepth .req r2
	cmp width, #4096
	cmpls height, #4096
	cmpls bitdepth, #32
	result .req r0
	movhi result, #0			@ If the width, height or bitdepth are too large, return 0
	movhi pc, lr

	push {lr}
	frameBuffInfoAddr .req r3
	ldr frameBuffInfoAddr, =FrameBufferInfo
	str width, 		[frameBuffInfoAddr, #0]
	str height, 	[frameBuffInfoAddr, #4]
	str width, 		[frameBuffInfoAddr, #8]
	str height, 	[frameBuffInfoAddr, #12]
	str bitdepth, 	[frameBuffInfoAddr, #20]
	.unreq width
	.unreq height
	.unreq bitdepth

	mov r0, frameBuffInfoAddr
	offset .req r2
	mov offset, #1
	lsl offset, #30
	add r0, offset
	.unreq offset
	mov r1, #1
	bl MailboxWrite

	mov r0, #1
	bl MailboxRead

	teq result, #0
	movne result, #0
	popne {pc}

	mov result, frameBuffInfoAddr
	.unreq result
	.unreq frameBuffInfoAddr
	pop {pc}
