.text
.global main

main:
   	# Copy the current value of $cctrl into $2
	movsg $2, $cctrl
	# Mask (disable) all interrupts
	andi $2, $2, 0xf
	# Enable IRQ2 and IRQ3
	ori $2, $2, 0xC2
	# Copy the new CPU control value back to $cctrl
	movgs $cctrl, $2
	# Copy the old handler¡¯s address to $2
	movsg $2, $evec
	# Save it to memory
	sw $2, old_vector($0)
	# Get the address of our handler
	la $2, handler
	# And copy it into the $evec register
	movgs $evec, $2
	# Acknowledge any outstanding interrupts
	sw $0,0x72003($0)
	sw $0,0x73005($0)
	#open the Control Register
	addi $7,$0,0x3
	sw $7,0x73004($0)
	#set initial value
	sw $0,counter($0)
	sw $0,flag($0)
	# Put our count value into the timer load reg
	addi $7, $0, 0x960
	sw $7, 0x72001($0)
	#open the Control Register Automatic Restart
	addi $7,$0,0x2
	sw $7, 0x72000($0)
loop:
	lw $4,counter($0)
	divui $3,$4,1000
	#to avoid a number have more the 4 digit places
	remui $3,$3,10
	sw $3,0x73006($0)
	divui $3,$4,100
	remui $3,$3,10
	sw $3,0x73007($0)
	divui $3,$4,10
	remui $3,$3,10
	sw $3,0x73008($0)
	remui $3,$4,10
	sw $3,0x73009($0)
	lw $7,flag($0)
	beqz $7,loop
	jr $ra
handler:
	# Get the value of the exception status register
	movsg $13, $estat
	# Check if interrupt we don¡¯t handle ourselves
	andi $13, $13, 0xffb0
	# If it one of ours, go to our handler
	beqz $13, handle_IRQ2	
	# Get the value of the exception status register
	movsg $13, $estat
	# Check if interrupt we don¡¯t handle ourselves
	andi $13, $13, 0xff70
	# If it one of ours, go to our handler
	beqz $13, handle_IRQ3
	# Otherwise, jump to the default handler
	# that we saved earlier.
	lw $13, old_vector($0)
	jr $13
handle_IRQ2: 
	lw $13, counter($0)
	addi $13, $13, 1
	sw $13, counter($0)
	addi $13, $0, 0
	sw $13,0x72003($0)
	rfe
handle_IRQ3:
	#if is not open than go back
	lw $13,0x73001($0)
	beqz $13,back_IRQ3
	#Otherwise go to each buttun
	andi $13,$13,0x1
	bnez $13,push_zero
	lw $13,0x73001($0)
	andi $13,$13,0x2
	bnez $13,push_one
	lw $13,0x73001($0)
	andi $13,$13,0x4
	bnez $13,push_two
push_zero:
	lw $13, 0x72000($0)
	xori $13,$13,0x1
	sw $13, 0x72000($0)
	j back_IRQ3

push_one:
	#if is running than do nothing
	lw $13, 0x72000($0)
	andi $13,$13,0x1
	bnez $13, back_IRQ3
	#Otherwise restore the counter
	addi $13, $0, 0
	sw $13, counter($0)
	j back_IRQ3
push_two:
	#exit the program
	addi $13,$0,1
	sw $13, flag($0)
back_IRQ3:
	addi $13,$0,0
	sw $13,0x73005($0)
	rfe
	
.bss
old_vector:
	.word
counter:
	.word 
flag:
	.word



