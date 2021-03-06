.text
.global main

# Define register
.equ Timer_Control_Register, 0x72000
.equ Timer_Load_Register, 0x72001
.equ Timer_Interrupt_Register, 0x72003

# PCB (With Link)
.equ pcb_link, 0
.equ pcb_reg1, 1
.equ pcb_reg2, 2
.equ pcb_reg3, 3
.equ pcb_reg4, 4
.equ pcb_reg5, 5
.equ pcb_reg6, 6
.equ pcb_reg7, 7
.equ pcb_reg8, 8
.equ pcb_reg9, 9
.equ pcb_reg10, 10
.equ pcb_reg11, 11
.equ pcb_reg12, 12
.equ pcb_reg13, 13
.equ pcb_sp, 14
.equ pcb_ra, 15
.equ pcb_ear, 16
.equ pcb_cctrl, 17

main:
	# Copy the old handler¡¯s address to $2
	movsg $2, $evec
	# Save it to memory
	sw $2, old_vector($0)
	# Get the address of our handler
	la $2, handler
	# And copy it into the $evec register
	movgs $evec, $2	
	# IRQ2=1,KU=1,OKU=1,IE=0,OIE=1
	addi $5, $0, 0x4d

	# Setup the pcb for task 1
	la $1, task1_pcb
	# Setup the link field
	la $2, task2_pcb
	sw $2, pcb_link($1)
	# Setup the stack pointer
	la $2, task1_stack
	sw $2, pcb_sp($1)
	# Setup the $ear field
	la $2, serial_main
	sw $2, pcb_ear($1)
	# Setup the $cctrl field
	sw $5, pcb_cctrl($1)

	# Setup the pcb for task 2
	la $1, task2_stack
	# Setup the link field
	la $2, task1_pcb
	sw $2, pcb_link($1)
	# Setup the stack pointer
	la $2, task2_stack
	sw $2, pcb_sp($1)
	# Setup the $ear field
	la $2, parallel_main
	sw $2, pcb_ear($1)
	# Setup the $cctrl field
	sw $5, pcb_cctrl($1)

	sw $1, current_task($0)

	# Acknowledge any outstanding interrupts
	sw $0,Timer_Interrupt_Register($0)
	#set initial value
	# Put our count value into the timer load reg
	addi $11, $0, 0x18
	sw $11, Timer_Load_Register($0)
	#open the Control Register
	addi $7,$0,0x3
	sw $7,Timer_Control_Register($0)

	#jumping into the part of the dispatcher that loads context
	j load_context

handler:
	# Get the value of the exception status register
	movsg $13, $estat
	# Check if interrupt we don¡¯t handle ourselves
	andi $13, $13, 0xffb0
	# If it one of ours, go to our handler
	beqz $13, handle_IRQ2
	# Otherwise, jump to the default handler
	# that we saved earlier.
	lw $13, old_vector($0)
	jr $13

handle_IRQ2:
	addi $13,$0,0	
	sw $13,Timer_Interrupt_Register($0)
	lw $13,counter($0)
	addi $13,$13,1
	sw $13,counter($0)
	# Subtract 1 from the timeslice counter
	lw $13,timeslice($0)
	subui $13,$13,1
	sw $13,timeslice($0)
	# If timeslice counter is zero, go to dispatcher
	beqz $13,dispatcher

	# Return to the new task
	rfe

dispatcher:
save_context:
	# Get the base address of the current PCB
	lw $13, current_task($0)
	# Save the registers
	sw $1, pcb_reg1($13)
	sw $2, pcb_reg2($13)
	sw $3, pcb_reg3($13)
	sw $4, pcb_reg4($13)
	sw $5, pcb_reg5($13)
	sw $6, pcb_reg6($13)
	sw $7, pcb_reg7($13)
	sw $8, pcb_reg8($13)
	sw $9, pcb_reg9($13)
	sw $10, pcb_reg10($13)
	sw $11, pcb_reg11($13)
	sw $12, pcb_reg12($13)
	sw $sp, pcb_sp($13)
	sw $ra, pcb_ra($13)

	# $1 is saved now so we can use it
	# Get the old value of $13
	movsg $1, $ers
	# and save it to the pcb
	sw $1, pcb_reg13($13)	
	# Save $ear
	movsg $1, $ear
	sw $1, pcb_ear($13)
	# Save $cctrl
	movsg $1, $cctrl
	sw $1, pcb_cctrl($13)

schedule:
	#Get current task
	lw $13, current_task($0)
	#Get next task from pcb_link field
	lw $13, pcb_link($13) 
	#Set next task as current task
	sw $13, current_task($0)
	lw $13, timeslice($0)
	addi $13,$13,2
	sw $13, timeslice($0)

load_context:
	#Get PCB of current task
	lw $13, current_task($0)
	# Get the PCB value for $13 back into $ers
	lw $1, pcb_reg13($13)
	movgs $ers, $1
	# Restore $ear
	lw $1, pcb_ear($13)
	movgs $ear, $1
	# Restore $cctrl
	lw $1, pcb_cctrl($13)
	movgs $cctrl, $1
	# Restore the other registers
	lw $1, pcb_reg1($13)
	lw $2, pcb_reg2($13)
	lw $3, pcb_reg3($13)
	lw $4, pcb_reg4($13)
	lw $5, pcb_reg5($13)
	lw $6, pcb_reg6($13)
	lw $7, pcb_reg7($13)
	lw $8, pcb_reg8($13)
	lw $9, pcb_reg9($13)
	lw $10, pcb_reg10($13)
	lw $11, pcb_reg11($13)
	lw $12, pcb_reg12($13)
	lw $sp, pcb_sp($13)
	lw $ra, pcb_ra($13)

	# Return to the new task
	rfe

.bss
old_vector:
	.word

	.space 200
task1_stack:

task1_pcb:
	.space 18

	.space 200
task2_stack:

task2_pcb:
	.space 18
.data
timeslice:
	.word 2

current_task:
	.word 18




