.text
.global main

main:
	subui $sp,$sp,4
	sw $2,0($sp)
	sw $3,1($sp)
	sw $4,2($sp)
	sw $5,3($sp)

	add $5,$ra,$0

	jal readswitches
	
	andi $3,$1,0xff
	srli $4,$1,8
	
	subui $sp,$sp,2
	sw $3,0($sp)
	sw $4,1($sp)
	jal count
	addui $sp,$sp,2

	add $ra,$5,$0

	lw $2,0($sp)
	lw $3,1($sp)
	lw $4,2($sp)
	lw $5,3($sp)
	addui $sp,$sp,4

	jr $ra
