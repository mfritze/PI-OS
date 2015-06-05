@ Takes the desired timer value in micrseconds in r0, and 
@ returns when that much time has elapsed.
.globl Timer
Timer:
	@ TODO update to support 8 byte timers
	push {lr}
	timerArg .req r2
	mov timerArg, r0

	timerBaseLower .req r3
	@timerBaseUpper .req r4
	bl GetTimeStamp
	mov timerBaseLower, r0
	@mov timerBaseUpper, r1

	@ Loop until the timerArg micrseconds have passed
	waitLoop$: 
		bl GetTimeStamp
		difference .req r4
		sub  difference, r0, timerBaseLower
		cmp  difference, timerArg
		.unreq difference
		bls waitLoop$

	.unreq timerArg
	.unreq timerBaseLower
	pop {pc}

.globl GetSystemTimerAddress
GetSystemTimerAddress:
	ldr r0, =0x20003000
	mov pc, lr

.globl GetTimeStamp
GetTimeStamp:
	push {lr}
	bl GetSystemTimerAddress
	ldrd r0, r1, [r0, #4]
	pop {pc}

