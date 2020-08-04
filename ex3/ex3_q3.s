.text
.global main

main:
	#Waits for any of the three horizontal push buttons to be pressed
	lw $2,0x73001($0)
	beqz $2,main
	#open the Control Register
	addi $7,$0,1
	sw $7,0x73004($0)
	#read switches
	lw $1,0x73000($0)
	#Checks which button was pressed
	andi $3,$2,0x1
	bnez $3,light
	andi $3,$2,0x2
	bnez $3,change
	andi $3,$2,0x4
	bnez $3,return

change:
	#invert the switch value
	xori $1,$1,0xffff
	j light

return:
	#exit the program
	jr $ra	
	
light:
	#Take the remainder and if remainder if is zero than open the light
	remi $5,$1,4
	beqz $5,on
	addi $6,$0,0
	sw $6,0x7300A($0)
	j number
on:
	addi $6,$0,0xffff
	sw $6,0x7300A($0)
	j number 

number:
	#Displays the value on the SSDs as a four-digit hexadecimal number.
	sw $1,0x73009($0)
	srli $4,$1,4
	sw $4,0x73008($0)
	srli $4,$4,4
	sw $4,0x73007($0)
	srli $4,$4,4
	sw $4,0x73006($0)
	j main
