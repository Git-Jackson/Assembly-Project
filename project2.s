# ---- add comment ---- #
.data
PRINT1:	.asciiz "Enter the first integer: "
PRINT2: .asciiz "Enter the second integer: "
PRINT3:	.asciiz "The GCD: "
PRINT4:	.asciiz "The LCM: "
NL: .asciiz "\n"

.globl main
.text

main:

addi $t1, $zero, 0	#index = 0

la $a0, PRINT1	#calling user input for n1
li $v0, 4
syscall
li $v0, 5
syscall
add $a1, $v0, $zero	#$a1 = n1

la $a0, PRINT1	#calling user input for n2
li $v0, 4
syscall
li $v0, 5
syscall
add $a2, $v0, $zero	#$a2 = n2

la $a0, NL
li $v0, 4
syscall

# ---- input validation -----
add $t0, $a1, $a2
beq	$t0, 0, main
bgt $a1, 255, main
bgt $a2, 255, main
blt	$a1, 0, main
blt $a2, 0, main
# ---- input validation ----

slt $t1, $a1, $a2	#determine if n1 is less than n2

beq $t1, $zero, N2LESS	#if n2 is less, branch to N2LESS

beq $t1, 1, N1LESS	#if n1 is less, branch to N1LESS

N2LESS:
move $t5, $a2	#swap a1 and a2 (n1 and n2)
move $a2, $a1
move $a1, $t5

N1LESS:

bge $t1, $a1, PRINT	#while index is than the smaller user inputed integer

sub $s0, $a1, $t1	#subtract i++ from a1 and store into $s0
div $a2, $s0	#divide the larger inputed integer by $s0
mfhi $s1	#store the remainder in $s1
addi $t1, $t1, 1	#i++

bne $s1, $zero, N1LESS	#return to the top if the remainder != 0
div $a1, $s0	#Now divide the smaller integer by the larger integer's factor
mfhi $s2	#store the remainder

beq $s2, $zero, GCD	#if the remainder is zero, then the GCD was found

j N1LESS #if remainder not zero, return to the top

GCD:
	move $a3, $s0	#store GCD in $a3
	jal LCM	#jump to LCM

LCM:
mul $s3, $a1, $a2	#perform calculation for LCM
div $s3, $a3
mflo $s4	#store the quotient(LCM) in $s4

PRINT:
	la $a0, PRINT3 #print GCD & LCM!
	li $v0, 4
	syscall
	move $a0, $a3
	li $v0, 1
	syscall
	la $a0, NL
	li $v0, 4
	syscall
	la $a0, PRINT4
	li $v0, 4
	syscall
	move $a0, $s4
	li $v0, 1
	syscall
	li $v0, 10
	syscall