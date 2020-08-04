.text
.global main

main:
	addi $2,$0,'a'
	addi $3,$0,'z'
	addi $6,$0,0

loop:
	lw $4,0x71003($0)
	andi $4,$4,0x2
	beqz $4,loop	
	sw $2,0x71000($0)
	addi $2,$2,1
	sle $4,$2,$3
	bnez $4,loop
	beqz $6,change
	jr $ra

change:
	addi $2,$0,'A'
	addi $3,$0,'Z'
	addi $6,$0,1
	j loop
