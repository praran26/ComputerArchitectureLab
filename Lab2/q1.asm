			.data
prompt1: 	.asciiz "Enter 1st integer: "
prompt2: 	.asciiz "Enter 2nd integer: "
ans:		.asciiz "GCD: "
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
			
			# jump to euclid
			j euclid

euclid:
			# if t0=0 or t1=0, print t0+t1
			beqz $t0,print_answer 		
			beqz $t1,print_answer
			# if t0<=t1: call first_small [t1%=t0; eulcid;]
			ble $t0,$t1,first_small 
			# if t0>t1: call second_small [t0%=t1; eulcid;]	
			bgt $t0,$t1,second_small

print_answer:
			li $v0,4
			la $a0,ans
			syscall

			li $v0,1 					# print answer
			add $a0,$t0,$t1
			syscall

			# exit
			li $v0,10
			syscall
first_small:
			rem $t1,$t1,$t0
			j euclid
second_small:
			rem $t0,$t0,$t1
			j euclid