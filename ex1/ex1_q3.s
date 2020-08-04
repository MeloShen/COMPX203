.text
.global main
 
main:	
	jal readswitches
	addi $2, $0,0
loop:
	andi $3,$1,1
	add  $2,$2,$3 
	srli $1,$1,1 
	bnez $1, loop
	lw $2,letters($2)
	jal writessd
	j main



	

.data
letters:
	.word 0xA3
	.word 0x22
	.word 0x6B
	.word 0x0D
	.word 0x49
	.word 0x90
	.word 0x7F
	.word 0xB8
	.word 0x51
	.word 0xC7
	.word 0xE6
	.word 0x1E
	.word 0x85
	.word 0xD4
	.word 0x3C
	.word 0xFA
	.word 0x42

