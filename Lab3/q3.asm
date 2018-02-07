# Sort an array using merge sort algorithm.
			.data
			.align 2
arr:		.space 1024
temp:		.space 1024
inputlen:	.asciiz "Enter the number of elements: "
inputnum:	.asciiz "Enter array elements: "
newline:	.asciiz "\n"
			.text
main:
			# Input array

			li $v0,4
			la $a0,inputlen
			syscall

			li $v0,5
			syscall
			move $t8,$v0

			li $v0,4
			la $a0,inputnum
			syscall

			la $t9,arr

			sw $ra,($sp)
			addi $sp,$sp,-8
			jal getinput
			addi $sp,$sp,8
			lw $ra,($sp)

			sw $ra,($sp)
			addi $sp,$sp,-8
			jal sort
			addi $sp,$sp,8
			lw $ra,($sp)
			
			sw $ra, ($sp)
			addi $sp,$sp,-8
			jal output
			addi $sp,$sp,8
			lw $ra, ($sp)


			j exit

# ..............................................
# Sorts array at $t9 with $t8 words
sort:
			# Check base case
			addi $t8, $t8, -1
			beqz $t8,sort_done
			addi $t8, $t8, 1

			# Push current args on stack
			sw $t8,($sp)
			addi $sp,$sp,-8
			sw $t9,($sp)
			addi $sp,$sp,-8

			# Recursion left
			sra $t8, $t8, 1
			sw $ra, ($sp)
			addi $sp, $sp, -8
			jal sort
			addi $sp, $sp, 8
			lw $ra, ($sp)

			# Restore current args from stack
			lw $t9, 8($sp)
			lw $t8, 16($sp)
			
			# Recursion right
			sra $t2, $t8, 1			# $t2 = $t8 / 2
			sub $t8, $t8, $t2		# $t8 = $t8 - $t2 (ceil ($t8 / 2))
			sll $t2, $t2, 2			# $t2 = 4 * $t2
			add $t9, $t9, $t2
			
			sw $ra, ($sp)
			addi $sp, $sp, -8
			jal sort
			addi $sp, $sp, 8
			lw $ra, ($sp)

			# Restore current args from stack
			lw $t9, 8($sp)
			lw $t8, 16($sp)
			
			# Setup args for merge
			sra $a2, $t8, 1
			sub $a3, $t8, $a2
			move $t5,$t9
			add $t9, $t9, $a2
			add $t9, $t9, $a2
			add $t9, $t9, $a2
			add $t9, $t9, $a2
			move $t6,$t9

			sw $ra, ($sp)
			addi $sp, $sp, -8
			jal merge
			addi $sp, $sp, 8
			lw $ra, ($sp)

			# Restore current args from stack
			lw $t9, 8($sp)
			lw $t8, 16($sp)
			
			# Copy $t8 elements from temp to $t9

			sw $ra, ($sp)
			addi $sp, $sp, -8
			jal copy
			addi $sp, $sp, 8
			lw $ra, ($sp)

			# Popping arguments to this call
			addi $sp, $sp, 16

			jr $ra

sort_done:
			li $t8,1
			jr $ra

# ..............................................
copy:
			li $t0,0
			li $t1,0
copyloop:
			beq $t0,$t8,copydone
			lw $t7, temp($t1)
			add $t9,$t9,$t1
			sw $t7,0($t9)
			sub $t9,$t9,$t1
			addi $t0,1
			addi $t1,4
			j copyloop
copydone:
			jr $ra

# ..............................................
# Merges sorted arrays
# a2: length of first array
# a3: length of second array
# t4: address of result array
# t5: address of first array
# t6: address of second array

merge:
			li $t0,0 	# index for arr1
			li $t1,0 	# index for arr2
			li $s5,0 	# 4 * index of arr1
			li $s6,0 	# 4 * index of arr2
merge_process:
			slt $s1, $t0, $a2	# s1 = $t0 < $a2
			slt $s2, $t1, $a3	# s2 = $t1 < $a3
			and $s0, $s1, $s2	# s0 = ($t0 < $a2) AND ($t1 < $a3)
			bne $s0, $zero, compare_merge
			bne $s1, $zero, first_merge
			bne $s2, $zero, second_merge
			jr $ra
compare_merge:
			add $t5,$t5,$s5
			add $t6,$t6,$s6
			lw $s3, 0($t5)
			lw $s4, 0($t6)
			sub $t5,$t5,$s5
			sub $t6,$t6,$s6
			blt $s3,$s4,first_merge
			b second_merge
first_merge:
			add $t5,$t5,$s5
			lw $t7, 0($t5)
			sub $t5,$t5,$s5
			add $s7,$s5,$s6
			sw $t7, temp($s7)
			addi $t0,1
			addi $s5,4
			j merge_process
second_merge:
			add $t6,$t6,$s6
			lw $t7, 0($t6)
			sub $t6,$t6,$s6
			add $s7,$s5,$s6
			sw $t7, temp($s7)
			addi $t1,1
			addi $s6,4
			j merge_process

# ..............................................
getinput:								# Resets counter and inputs $t8 words at address $t9
			li $t0,0
			li $t1,0
inputloop:			
			beq $t0, $t8, inputdone
			li $v0,5
			syscall
			add $t9,$t9,$t1
			sw $v0, 0($t9)
			sub $t9, $t9, $t1
			addi $t0, $t0, 1
			addi $t1, $t1, 4
			j inputloop
inputdone:
			jr $ra

# ..............................................
output: 								# Resets counters and outputs $t8 words from address $t9
			li $t0,0
			li $t1,0
outputloop:
			beq $t0, $t8, outputdone
			li $v0,4
			la $a0,newline
			syscall
			li $v0,1
			add $t9,$t9,$t1
			lw $a0,0($t9)
			syscall
			sub $t9,$t9,$t1
			addi $t0,$t0,1
			addi $t1,$t1,4
			j outputloop
outputdone:
			jr $ra

# ..............................................
exit:
			li $v0,10
			syscall

			