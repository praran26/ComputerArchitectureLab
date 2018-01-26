			.text
main:
			# li $t1,0x10000001 equivalent to
			lui $t1, 0x1000 # load upper immediate t1=0x1000<<16
			ori $t1, 0x0001 # or immediate t1=t1|0x0001
			# li $t2,0x20000002
			lui $t2, 0x2000
			ori $t2, 0x0002
			# add (t3=0x30000003)
			add $t3,$t1,$t2
			
			jr $ra