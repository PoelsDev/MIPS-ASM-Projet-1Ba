	.text
main:
	li $t0, 0 #i
	li $t1, 0 #a
	
	la $t2, default # Hier laadt ik enkele veel gebruikte jump cases in een temp register om zo met jr ze te kunnen uitvoeren.
	la $t3, endcase
	
switchcase:
	beq $t0, 0, case0  # Er wordt gejumpt naar case0.
	beq $t0, 1, case1  # Er wordt gejumpt naar case1.
	beq $t0, 2, case2  # Er wordt gejumpt naar case2.
	jr $t2  # Er wordt gejumpt naar het label geladen in $t2.
	
case0:
	li $t1, 9 # De waarde van a verandert naar 9 en er wordt gejumpt naar endcase.
	jr $t3  # Er wordt gejumpt naar het label geladen in $t3.
	
case1:
	li $t1, 6 # case1 verandert de waarde maar gaat niet naar endcase en gaat daarom altijd overschreden worden door de opvolgende cases (tot volgende endcase).
	
case2:
	li $t1, 8  # De waarde van a verandert naar 8 en er wordt gejumpt naar endcase
	jr $t3
	
default:
	li $t1, 7 # Default: verander in elk ander geval (of in het geval van case1) de waarde naar 7.
	jr $t3 # jump naar endcase
	
endcase:
	move $a0, $t1 # de waarde van a wordt hier afgeprint.
	li $v0, 1
	syscall
	
	li $v0, 10 # Het programma sluit af.
	syscall
