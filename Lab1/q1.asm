# Add the integers 1 and 2 using appropriate instructions

			.text
main:
			li $t1,1
			li $t2,2

			add $t3,$t1,$t2
			
			li $v0,10
			syscall