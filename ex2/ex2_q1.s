.global	count
.text
count:
	subui	$sp, $sp, 7
	sw	$5, 1($sp)
	sw	$6, 2($sp)
	sw	$7, 3($sp)
	sw	$12, 4($sp)
	sw	$13, 5($sp)
	sw	$ra, 6($sp)
	lw	$13, 7($sp)
	sgt	$13, $0, $13
	bnez	$13, L.6
	addui	$6, $0, 1
	j	L.7
L.6:
	addu	$6, $0, $0
L.7:
	sgei	$13, $6, 10000
	bnez	$13, L.2
	lw	$13, 8($sp)
	sgt	$13, $0, $13
	bnez	$13, L.8
	addui	$5, $0, 1
	j	L.9
L.8:
	addu	$5, $0, $0
L.9:
	sgei	$13, $5, 10000
	bnez	$13, L.2
	lw	$13, 7($sp)
	lw	$12, 8($sp)
	sge	$13, $13, $12
	bnez	$13, L.10
	lw	$7, 7($sp)
	j	L.15
L.12:
	sw	$7, 0($sp)
	jal	writessd
	jal	delay
L.13:
	addi	$7, $7, 1
L.15:
	lw	$13, 8($sp)
	sle	$13, $7, $13
	bnez	$13, L.12
	j	L.11
L.10:
	lw	$7, 7($sp)
	j	L.19
L.16:
	sw	$7, 0($sp)
	jal	writessd
	jal	delay
L.17:
	subi	$7, $7, 1
L.19:
	lw	$13, 8($sp)
	sge	$13, $7, $13
	bnez	$13, L.16
L.11:
L.2:
L.1:
	lw	$5, 1($sp)
	lw	$6, 2($sp)
	lw	$7, 3($sp)
	lw	$12, 4($sp)
	lw	$13, 5($sp)
	lw	$ra, 6($sp)
	addui	$sp, $sp, 7
	jr	$ra
