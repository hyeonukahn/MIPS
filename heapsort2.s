.data

	indata: .word 0:128
	length: .word 0
	newLine: .asciiz "\n"
	message: .asciiz "input numbers(-100=exit)\n"
	outmsg: .asciiz "sorted number:\n"
	space: .asciiz  " "
	swapmsg: .asciiz "swapped\n"
	point: .word 0

.text
	main:
	
	addi $t0, $zero, 0
	
	li $v0, 4
	la $a0, message
	syscall
	#input num, output num
	Loop:
		#question input
		li $v0, 5
		syscall
		move $t1, $v0
		#exit
		beq $t1, -100, exit
		
		sw $t1, indata($t0)
		
		addi $t0, $t0, 4
		addi $t1, $t0, 0
		div $t1, $t0, 4
		sw $t1, length
		sw $t0, point
		
		li $v0, 1
		move $a0, $t1
		syscall
		
		blt $t0, 12, passheap
		
		la $a0, indata
		lw $a1, length($zero)
				
		jal heapsort

		passheap:
		lw $t0, point
		
		#compare two value
		addi $a1, $t0, -8 #n-1 th value
		addi $a2, $t0, -4 #n th value
		lw $t1, indata($a1)
		lw $t2, indata($a2)

		blt $t1, $t2, passswap
		
		passswap:
		addi $a1, $t0, 0
		jal printout
		
		j Loop
	exit:

	li $v0, 10
	syscall
	
	#output func
	printout:
		li $v0, 4
		la $a0, outmsg
		syscall
		
		addi $t2, $zero, 0
		Loop2:
			addi $a1, $a1, -4
			lw $t3, indata($a1)

			li $v0, 1
			move $a0, $t3
			syscall
			
			li $v0, 4
			la $a0, space
			syscall
						
			beq $a1, $t2, exit2
			
			
		j Loop2
	
		exit2:
		li $v0, 4
		la $a0, newLine
		syscall
		
		jr $ra

		swap:

		lw $t1, indata($a1)
		lw $t2, indata($a2)
		sw $t1, indata($a2)
		sw $t2, indata($a1)

		jr $ra



  
done:
  jr $ra

heapsort: # a0 = &array, a1 = length
  addi $sp, $sp, -12
  sw $a1, 0($sp)  # save size
  sw $a2, 4($sp)  # save a2
  sw $ra, 8($sp)  # save return address
  
  
  move $a2, $a1  # n will be stored in a2
  addi $a2, $a2, -1    # n = size - 1
  ble $a2,$zero, end_heapsort  # n<0 end_heap;
  
  jal make_heap  # a0 = arr, a1 = size
  
  add $a1, $zero, $zero # clear $a1
heapsort_loop:
  # swap
  lw $t0, 0($a0)
  sll $t1, $a2, 2  #t1 = bytes(n)
  add $t1, $t1, $a0
  lw $t2, 0($t1)
  sw $t0, 0($t1)
  sw $t2, 0($a0)
  
  addi $a2, $a2, -1 # n--
  jal bubble_down  # a0 = &array, a1 = 0, a2 = n
  
  bnez $a2, heapsort_loop
end_heapsort:
  lw $ra, 8($sp)
  lw $a2, 4($sp)
  lw $a1, 0($sp)
  addi $sp, $sp, 12
  jr $ra
  
make_heap: # a0 = &array, a1 = size
  addi $sp, $sp, -12
  sw $a1, 0($sp)
  sw $a2, 4($sp)
  sw $ra, 8($sp)
  
  addi $a2, $a1, -1  # a2 = size - 1
  
  addi $a1, $a1, -1  # start_index = size - 1
  srl $a1, $a1, 1  # start_index /= 2
  
  blt $a1, $zero, end_make_heap  # if(start_index < 0) return
  
make_heap_loop:
  jal bubble_down # a0 = &array, a1 = start_index, a2 = size-1
  addi $a1, $a1, -1
  ble $zero, $a1, make_heap_loop
  
end_make_heap:
  lw $ra, 8($sp)
  lw $a2, 4($sp)
  lw $a1, 0($sp)
  addi $sp, $sp, 12
  jr $ra

bubble_down: # a0 = &array, a1 = s_idx, a2 = end
  move $t0, $a1  # index = s_idx
  sll $t1, $t0, 1  # child = index*2+1
  addi $t1, $t1, 1
  
  bgt $t1, $a2, end_bubble_down
  
bubble_down_loop:

  #if ( child < end & arr[child] < arr[child+1] )
  ble $a2, $t1, skipinc
  sll $t3, $t1, 2  # get bytes(child)
  add $t3, $t3, $a0
  lw $t3, 0($t3)  # t3 = arr[child]
  sll $t4, $t1, 2 #get bytes(child)
  addi $t4, $t4, 4 #t4 = bytes(child+1)
  add $t4, $t4, $a0
  lw $t4, 0($t4)  #t4 = arr[child+1]
  ble $t4, $t3, skipinc
  
  addi $t1, $t1, 1  # child++
  
skipinc:
  sll $t3, $t0, 2  # get bytes(index)
  add $t3, $t3, $a0
  lw $t4, 0($t3)  #t4 = arr[index], t3 = &arr[index]
  
  sll $t5, $t1, 2  # get bytes(child)
  add $t5, $t5, $a0
  lw $t6, 0($t5)  #t6 = arr[child], t5 = &arr[child]
  
  ble $t6, $t4, end_bubble_down
  
  # swap(arr[index],arr[child])
  # note: t4 = arr[index], t6 = arr[child], t3 = &arr[index], t5 = &arr[child]
  sw $t4, 0($t5)
  sw $t6, 0($t3)
  
  move $t0, $t1  # index = child
  
  sll $t1, $t0, 1  # child = index*2+1
  addi $t1, $t1, 1
  ble $t1, $a2, bubble_down_loop
  
end_bubble_down:
  jr $ra

