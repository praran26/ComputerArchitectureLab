# Calculate factorial of a number.
			.data
inputnum:	.asciiz "Enter number: "
outputfact:	.asciiz "The factorial is: "
			.text
main:
			li $v0,4
			la $a0,inputnum
			syscall

			li $v0,5
			syscall
			move $t2,$v0
			
			sw $ra, ($sp)
			addi $sp,$sp,-8
			jal factorial
			addi $sp,$sp,8
			lw $ra, ($sp)

			li $v0,4
			la $a0,outputfact
			syscall

			li $v0,1
			move $a0,$t1
			syscall

			li $v0,10
			syscall

factorial:
			beqz $t2,factorial_zero
			addi $t2, $t2,-1
			sw $ra, ($sp)
			addi $sp,$sp,-8
			jal factorial
			addi $sp,$sp,8
			lw $ra, ($sp)
			addi $t2, $t2,1
			mul $t1,$t1,$t2
			jr $ra

factorial_zero:
			li $t1,1
			jr $ra