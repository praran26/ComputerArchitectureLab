# Merge two sorted arrays.
			.data
			.align 2
arr1:		.space 1024
arr2:		.space 1024
res:		.space 2048
inputlen1:	.asciiz "Enter length of 1st array: "
inputlen2:	.asciiz "Enter length of 2nd array: "
input1: 	.asciiz "Enter elements of 1st array:\n"
input2: 	.asciiz "Enter elements of 2nd array:\n"
newline:	.asciiz "\n"
			.text
main:
			la $t5,arr1
			la $t6,arr2
			la $t4,res

			# Input first array length and its elements at arr1
			li $v0,4
			la $a0,inputlen1
			syscall

			li $v0,5
			syscall
			move $t8,$v0
			move $t2,$v0
			move $t9,$t5

			li $v0,4
			la $a0,input1
			syscall

			sw $ra,($sp) 				# Store current return address on stack
			addi $sp,$sp,-8 			# Extend stack
			jal getinput				# Function call
			addi $sp,$sp,8 				# Compress stack
			lw $ra,($sp) 				# Extract return address from stack

			# Input second array length and its elements at arr2
			li $v0,4
			la $a0,inputlen2
			syscall

			li $v0,5
			syscall
			move $t8,$v0
			move $t3,$v0
			move $t9,$t6

			li $v0,4
			la $a0,input2
			syscall

			sw $ra,($sp)
			addi $sp,$sp,-8
			jal getinput
			addi $sp,$sp,8
			lw $ra,($sp)

			# Merge sorted arrays
			sw $ra, ($sp)
			addi $sp,$sp,-8
			jal merge
			addi $sp,$sp,8
			lw $ra, ($sp)

			# Output merged array
			add $t8,$t2,$t3
			move $t9,$t4
			sw $ra, ($sp)
			addi $sp,$sp,-8
			jal output
			addi $sp,$sp,8
			lw $ra, ($sp)

			# Exit
			j exit

# ..............................................
# Merges sorted arrays
# t2: length of first array
# t3: length of second array
# t4: address of result array
# t5: address of first array
# t6: address of second array

merge:
			li $t0,0 	# index for arr1
			li $t1,0 	# index for arr2
			li $s5,0 	# 4 * index of arr1
			li $s6,0 	# 4 * index of arr2
merge_process:
			slt $s1, $t0, $t2	# s1 = $t0 < $t2
			slt $s2, $t1, $t3	# s2 = $t1 < $t3
			and $s0, $s1, $s2	# s0 = ($t0 < $t2) AND ($t1 < $t3)
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
			lw $t7, arr1($s5)
			add $s7,$s5,$s6
			sw $t7, res($s7)
			addi $t0,1
			addi $s5,4
			j merge_process
second_merge:
			lw $t7, arr2($s6)
			add $s7,$s5,$s6
			sw $t7, res($s7)
			addi $t1,1
			addi $s6,4
			j merge_process
# ..............................................

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
