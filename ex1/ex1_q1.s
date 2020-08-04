.text
.global main
 
main:	
	jal readswitches
	addi $2,$1,0
	jal writessd
	j main

