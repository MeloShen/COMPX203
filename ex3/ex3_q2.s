.text
.global main

main:
	#save the range and the star
	addi $2,$0,'a'
	addi $3,$0,'z'
	addi $4,$0,'*'

loop:
	#Reads a character from serial port 1
	lw $7,0x70003($0)
	andi $7,$7,0x1
	beqz $7,loop
	#read switches
	lw $1,0x70001($0)
	#check if is bigger than a
	sge $5,$1,$2
	#is smaller than z
	sle $6,$1,$3
	#not meet the two conditions tha go to change and output  ' * '
	and $5,$5,$6
	beqz $5,star
	bnez $5,character

character:
	lw $7,0x70003($0)
	andi $7,$7,0x2
	beqz $7,character
	sw $1,0x70000($0)
	j loop
star:
	lw $7,0x70003($0)
	andi $7,$7,0x2
	beqz $7,star
	sw $4,0x70000($0)
	j loop

