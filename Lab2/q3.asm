			.data
prompt1: 	.asciiz "Enter 1st integer: "
prompt2: 	.asciiz "Enter 2nd integer: "
ans:		.asciiz "The sum is: "
			.globl main
			.text
main:
			# input 1
			li $v0,4
			la $a0,prompt1
			syscall

			li $v0,5
			syscall
			move $t0,$v0

			# input 2
			li $v0,4
			la $a0,prompt2
			syscall

			li $v0,5
			syscall
			move $t1,$v0
			
			# output string
			li $v0,4
			la $a0,ans
			syscall

			# add a0=t1+t0
			add $a0,$t1,$t0

			li $v0,1
			syscall

			# exit
			li $v0,10
			syscall
