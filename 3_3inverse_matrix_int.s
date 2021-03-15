.data
#	array, 4byte for int =>arraysize 3
#	myArray: .word 100:3 #3elements => 100
	messagein: .asciiz "input 9 values(3X3)\n"
	myArray: .word 0:9
	myArray2: .word 0:9
	newLine: .asciiz "\n"
	space: .asciiz " "
	det: .word 0
	
.text
	main:
	
	li $v0, 4
	la $a0, messagein
	syscall
		
	# Index = $t0
	addi $t0, $zero, 0
	
	#input 9 values
	whilein:
		beq $t0, 36, exitin
		addi $s0, $zero, 0
		
		li $v0, 5
		syscall
		
		move $a0, $v0
		addi $s0, $a0, 0
		
		sw $s0, myArray($t0)
		addi $t0, $t0, 4
	
		j whilein
		
	exitin:
	#determinant
	addi $a0, $zero, 16
	addi $a1, $zero, 32
	addi $a2, $zero, 20
	addi $a3, $zero, 28

	jal det2
	
	addi $t0, $zero, 0
	lw $t1, myArray($t0)
	
	mul $s1, $t1, $v1
	
#------------------------------------------------------
	
	addi $a0, $zero, 12
	addi $a1, $zero, 32
	addi $a2, $zero, 20
	addi $a3, $zero, 24

	jal det2

	addi $t0, $zero, 4
	lw $t1, myArray($t0)
	
	mul $s2, $t1, $v1
	
#---------------------------------------------

	addi $a0, $zero, 12
	addi $a1, $zero, 28
	addi $a2, $zero, 16
	addi $a3, $zero, 24

	jal det2
	
	addi $t0, $zero, 8
	lw $t1, myArray($t0)
	
	mul $s3, $t1, $v1
	
	move $t1, $s1
	move $t2, $s2
	move $t3, $s3
	
	sub $t0, $t1, $t2
	add $t0, $t0, $t3
	sw $t0, det($zero)
#-----------------------------------------------------------
	
	lw $a0, det($zero)
	li $v0, 1
	syscall

#---------------------------------------------------------
	addi $t5, $zero, 0
#
	addi $a0, $zero, 16
	addi $a1, $zero, 32
	addi $a2, $zero, 20
	addi $a3, $zero, 28

	jal det2
	
	lw $t1, det($zero)
	div $t2, $v1, $t1
	
	sw $t2, myArray2($t5)
	addi $t5, $t5, 4

#	
	addi $a0, $zero, 4
	addi $a1, $zero, 32
	addi $a2, $zero, 8
	addi $a3, $zero, 28

	jal det2
	
	lw $t1, det($zero)
	div $v1, $v1, $t1
	mul $v1, $v1, -1
	
	sw $v1, myArray2($t5)
	addi $t5, $t5, 4
#	
#
	addi $a0, $zero, 4
	addi $a1, $zero, 20
	addi $a2, $zero, 8
	addi $a3, $zero, 16

	jal det2
	
	lw $t1, det($zero)
	div $v1, $v1, $t1
	
	sw $v1, myArray2($t5)
	addi $t5, $t5, 4
#	
#
	addi $a0, $zero, 12
	addi $a1, $zero, 32
	addi $a2, $zero, 20
	addi $a3, $zero, 24

	jal det2
	
	lw $t1, det($zero)
	div $v1, $v1, $t1
	mul $v1, $v1, -1
	
	sw $v1, myArray2($t5)
	addi $t5, $t5, 4
#	
#
	addi $a0, $zero, 0
	addi $a1, $zero, 32
	addi $a2, $zero, 8
	addi $a3, $zero, 24

	jal det2
	
	lw $t1, det($zero)
	div $v1, $v1, $t1
	
	sw $v1, myArray2($t5)
	addi $t5, $t5, 4
#	
#
	addi $a0, $zero, 0
	addi $a1, $zero, 20
	addi $a2, $zero, 8
	addi $a3, $zero, 12

	jal det2
	
	lw $t1, det($zero)
	div $v1, $v1, $t1
	mul $v1, $v1, -1
	
	sw $v1, myArray2($t5)
	addi $t5, $t5, 4
#	
#
	addi $a0, $zero, 12
	addi $a1, $zero, 28
	addi $a2, $zero, 16
	addi $a3, $zero, 24

	jal det2
	
	lw $t1, det($zero)
	div $v1, $v1, $t1
	
	sw $v1, myArray2($t5)
	addi $t5, $t5, 4
#	
#
	addi $a0, $zero, 0
	addi $a1, $zero, 28
	addi $a2, $zero, 4
	addi $a3, $zero, 24

	jal det2
	
	lw $t1, det($zero)
	div $v1, $v1, $t1
	mul $v1, $v1, -1
	
	sw $v1, myArray2($t5)
	addi $t5, $t5, 4
#	
#
	addi $a0, $zero, 0
	addi $a1, $zero, 16
	addi $a2, $zero, 4
	addi $a3, $zero, 12

	jal det2
	
	lw $t1, det($zero)
	div $v1, $v1, $t1
	
	sw $v1, myArray2($t5)
#	
#

	
	
	
#------------------------------
	
	li $v0, 4
	la $a0, newLine
	syscall
	#print 3x3 matrix
	addi $t0, $zero, 0
	
	whileout:
		beq $t0, 36, exitout
		
		lw $t6, myArray($t0)
		
		addi $t0, $t0, 4
		
		#print num
		li $v0, 1
		move $a0, $t6
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		

		addi $t1, $t0, 0
		addi $t2, $zero, 12
		div $t1, $t2
		mflo $t4 #quo
		mfhi $t5 #remainder
		
		bne $t5, 0, jump
			li $v0, 4
			la $a0, newLine
			syscall
		jump:
		
		j whileout
		
	exitout:
	
	addi $t0, $zero, 0
	whileout2:
		beq $t0, 36, exitout2
		
		lw $t6, myArray2($t0)
		
		addi $t0, $t0, 4
		
		#print num
		li $v0, 1
		move $a0, $t6
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		

		addi $t1, $t0, 0
		addi $t2, $zero, 12
		div $t1, $t2
		mflo $t4 #quo
		mfhi $t5 #remainder
		
		bne $t5, 0, jump2
			li $v0, 4
			la $a0, newLine
			syscall
		jump2:
		
		j whileout2
		
	exitout2:
	
	li $v0, 10
	syscall

	det2:
		addi $t0, $a0, 0
		lw $t1, myArray($t0)
		addi $t0, $a1, 0
		lw $t2, myArray($t0)
	
		mul $t3, $t1, $t2
	
		addi $t0, $a2, 0
		lw $t1, myArray($t0)
		addi $t0, $a3, 0
		lw $t2, myArray($t0)

		mul $t4, $t1, $t2
	
		sub $v1, $t3, $t4
		
		jr $ra