.globl GetMailboxBase
GetMailboxBase:
	ldr r0, =0x2000B880
	mov pc, lr

@ Takes the message to write in r0 (with lower 4 bits as 0s) 
@ and the 4bit mailbox code in r1
.globl MailboxWrite
MailboxWrite:
	tst r0, #0b1111 	@ Computes logical and, then compares with 0, equivalent to $ and r0, #0b1111, cmp r0, 0
	movne pc, lr 		@ If the lower 4 bits are not 0, return
	cmp r1, #15
	movhi pc, lr 		@ If the mailbox number is more than 15, return

	channel .req r1
	msg .req r2
	push {lr}
	mov msg, r0
	bl GetMailboxBase
	mailbox .req r0

	waitForStatus$:
		status .req r3
		ldr status, [mailbox, #0x18]
		tst status, #0x80000000
		.unreq status
		bne waitForStatus$

	add msg, channel
	.unreq channel
	str msg, [mailbox, #0x20]
	.unreq mailbox
	.unreq msg
	pop {pc}

@ Pass which mailbox to read from into r0.
.globl MailboxRead
MailboxRead:
	cmp r0, #15
	movhi pc, lr

	channel .req r1
	mov channel, r0
	push {lr}
	bl GetMailboxBase
	mailbox .req r0

	waitForStatus2$:
		status .req r2
		ldr status, [mailbox, #0x18]
		tst status, #0x40000000
		.unreq status
		bne waitForStatus2$

		msg .req r2
		ldr msg, [mailbox]
		mailChannel .req r3
		and mailChannel, msg, #0b1111
		teq mailChannel, channel
		.unreq mailChannel
		bne waitForStatus2$

	and msg, #0xfffffff0
	mov r0, msg
	.unreq mailbox
	.unreq channel
	.unreq msg

	pop {pc}

