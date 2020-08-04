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
	jal writessd
	j main


