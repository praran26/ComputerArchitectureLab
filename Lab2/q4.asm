			.data
			.align 2  	# align the next datum on a 2**2 byte boundary  
start:		.asciiz "Enter array elements:\n"
end:		.asciiz "Goodbye!"
prompt: 	.asciiz "Enter number: "
newline:  	.asciiz "\n"
arrsz:		.word 8 	# count of array elements
arr: 		.space 32 	# reserving 32-bytes for 8 words
			.text
main:
			# Initialize variables
			lw $t7, arrsz
			li $t0, 0
			li $t1, 0
			# Output prompt
			li $v0,4
			la $a0,start
			syscall 

			# Looping from 0 to arrsz to input numbers
inputloop:
			# Printing prompt and taking input
			beq $t0,$t7,init_to_zero
			li $v0,4
			la $a0,prompt
			syscall
			li $v0,5
			syscall
			# Store word from a0 to arr[t0]=arr+4*t0=arr+t1
			sw $v0, arr($t1)
			# Increment t0
			addi $t0, $t0, 1
			addi $t1, $t1, 4
			j inputloop

			# Looping from 0 to arrsz to output numbers
init_to_zero:
			li $t0, 0
			li $t1, 0
outputloop:
			beq $t0,$t7,exit
			# Output arr[t0] with a newline
			li $v0,1
			lw $a0, arr($t1)
			syscall
			li $v0,4
			la $a0,newline
			syscall
			# Increment t0
			addi $t0, $t0, 1
			addi $t1, $t1, 4
			j outputloop

exit:
			li $v0,4
			la $a0,end
			syscall
			# Exit
			li $v0,10
			syscall