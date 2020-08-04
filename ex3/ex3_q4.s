.text
.global main

main:
	subui $sp,$sp,1
	sw $ra,0($sp)
loop1:
	jal serial_job
	jal parallel_job
	bnez $1,exit
	j loop1
exit:
	lw $ra,0($sp)
	addui $sp,$sp,1

	jr $ra

serial_job:
	#save the range and the star
	addi $2,$0,'a'
	addi $3,$0,'z'
	addi $4,$0,'*'

loop2:
	#Reads a character from serial port 1
	lw $7,0x70003($0)
	andi $7,$7,0x1
	beqz $7,end1
	#read switches
	lw $1,0x70001($0)
	#check if is bigger than a
	sge $5,$1,$2
	#is smaller than z
	sle $6,$1,$3
	#not meet the two conditions tha go to change and output  ' * '
	and $5,$5,$6
	beqz $5,star
	
character:
	lw $7,0x70003($0)
	andi $7,$7,0x2
	beqz $7,end1	
	sw $1,0x70000($0)

star:
	lw $7,0x70003($0)
	andi $7,$7,0x2
	beqz $7,end1
	sw $4,0x70000($0)

end1:

	jr $ra
	
parallel_job:
	addi $1,$0,0
	#Waits for any of the three horizontal push buttons to be pressed
	lw $2,0x73001($0)
	beqz $2,end2
	#open the Control Register
	addi $7,$0,1
	sw $7,0x73004($0)
	#read switches
	lw $8,0x73000($0)
	#Checks which button was pressed
	andi $3,$2,0x1
	bnez $3,number
	andi $3,$2,0x2
	bnez $3,change
	addi $1,$0,1
	#exit the program
	j end2

change:
	#invert the switch value
	xori $8,$8,0xffff

number:
	#Displays the value on the SSDs as a four-digit hexadecimal number.
	sw $8,0x73009($0)
	srli $4,$8,4
	sw $4,0x73008($0)
	srli $4,$4,4
	sw $4,0x73007($0)
	srli $4,$4,4
	sw $4,0x73006($0)
	
light:
	#Take the remainder and if remainder if is zero than open the light
	remi $5,$8,4
	beqz $5,on
	addi $6,$0,0
	sw $6,0x7300A($0)
	j end2
on:
	addi $6,$0,0xffff
	sw $6,0x7300A($0)

end2:
	jr $ra

