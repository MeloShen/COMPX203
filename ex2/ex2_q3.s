.text
.global print

print:
	subui $sp,$sp,4
	sw $2,0($sp)
	sw $3,1($sp)
	sw $4,2($sp)
	sw $5,3($sp)
	add $5,$ra,$0
	
	lw $1, 4($sp)

	addi $2,$0,5
	addi $3,$0,10000
	
loop:
	divu $4,$1,$3
	remu $1, $1, $3
	addui $4,$4,'0'
	subui $sp,$sp,1
	sw $4,0($sp)
	jal putc
	addui $sp,$sp,1
	subui $2,$2,1
	divui $3,$3,10
	bnez $2,loop

clean:
	add $ra,$5,$0

	lw $2,0($sp)
	lw $3,1($sp)
	lw $4,2($sp)
	lw $5,3($sp)
	addui $sp,$sp,4

	jr $ra

