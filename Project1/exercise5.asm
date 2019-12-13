	.data
s1:	.asciiz "Prime"  # De nodige strings.
s2:	.asciiz "Not Prime"

	.text
main:
	li $v0, 5  # Hier read ik een integer om te checken op een priemgetal.
	syscall
	move $t0, $v0  # Deze zet ik in $tO.
	
	sub $t3, $t0, 1 # Ik sla een tweede getal $t0 - 1 op waarover ik kan loopen zonder het te testen getal te delen door zichzelf.
	
	li $t1, 2 # Ik maak een iterator die start van 2 omdat ik enkele gevallen apart check hieronder.
	
	beq $t0, 0, endmainNotPrime # Als de integer 0 is, is het geen priemgetal.
	beq $t0, 1, endmainPrime # Als de integer 1 is, is het een priemgetal.
	beq $t0, 2, endmainPrime # Als de integer 2 is, is het een priemgetal.
	
loop:
	bgt $t1, $t3, endmainPrime # In deze loop check ik of het te testen getal deelbaar is door de iterator die loopt van 2 tot de integer zelf -1.
	div $t0, $t1 # Deze instructie en de 2 instructies daarna doen de modulo berekening.
	mfhi $t6
	beq $t6, 0, endmainNotPrime
	
	addi $t1, $t1, 1 # Ik tel 1 op bij de iterator.
	j loop
	
	
endmainPrime: # endmainPrime zal zeggen dat het ingegeven getal een priemgetal is en het programma afsluiten.
	la $a0, s1
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
endmainNotPrime: # endmainNotPrime zal zeggen dat het ingegeven getal geen priemgetal is en het programma afsluiten.
	la $a0, s2
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	