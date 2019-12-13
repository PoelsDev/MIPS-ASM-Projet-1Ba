	.data
red:	.word 0x00ff0000  # Nodige kleuren, strings 
yellow: .word 0x00ffff00
s1:	.asciiz "\n"
s2:	.asciiz " x: "
s3: 	.asciiz "y: "

	.text
main:
	li $t0, 0  # counter 1 (x)
	li $t1, 0  # counter 2 (y)
	li $t7, 32 # Hardcoded grootte van de bitmap
	la $t6, yellow # De kleur geel wordt in het $t6 register geladen.
	
loop1:
	bge $t0, $t7, mainEnd # Hieronder staat een geneste loop die over de x & daarna y waarde loopt.
	
	la $a0, s2  # Print 'x:'
	li $v0, 4
	syscall
	
	move $a0, $t0 # Print de x waarde.
	li $v0, 1
	syscall
loop2:
	bge $t1, $t7, endLoop2 # In de tweede loop wordt het adres berekend (jal).
	
	jal calculateAddress
	lw $t8, ($t6) # De kleur yellow wordt geladen in $t8 en daarna op het juiste adres geplaatst.
	sw $t8, ($t4)
	
	la $a0, s3  # "y: " wordt geprint.
	li $v0, 4
	syscall
	
	move $a0, $t1 # De y-waarde van het adres wordt geprint.
	li $v0, 1
	syscall
	
	addi $t1, $t1, 1  # De counter van (y) wordt verhoogd.
	la $t6, red # Rood wordt geladen in de kleur register $t6.
	
	jal changeColor # Er wordt gecheckt of op dit adres (volgende loop) een gele kleur moet komen.
	j loop2  # Er wordt naar het begin van de tweede loop gesprongen.
	
endLoop2:
	la $t6, yellow  # Endloop2 wordt aangeroepen bij het einde van de tweede loop. De y-waarde wordt terug 0.
	li $t1, 0
	addi $t0, $t0, 1 # De x-waarde wordt met 1 verhoogd.
	j loop1 # Er wordt terug naar het begin van de 1ste loop gesprongen.
	
mainEnd:
	li $v0, 10  # Beëindigd het programma.
	syscall
	
changeColor: # Dit label gaat over meerdere mogelijke gevallen waarbij de kleur geel zal moeten zijn. (randblokjes)
	beq $t0, $zero, toYellow
	subi $t5, $t7, 1
	beq $t0, $t5, toYellow
	beq $t1, $zero, toYellow
	beq $t1, $t5, toYellow
	
	jr $ra  # Gaat terug naar de plek waar het aangeroepen is.
	
toYellow:
	la $t6, yellow  # Verandert de kleur in het $t6 register naar geel.
	j loop2
	
calculateAddress:
	mul $t3, $t0, 32  # Bereken de nieuwe coördinaat. (adres = (32 * x) + y)
	add $t3, $t3, $t1
	mul $t3, $t3, 4   # Bereken de weldegelijke coördinaat door het resultaat van hierboven *4 te doen en daarna dit bij $gp op te tellen.
	add $t4, $gp, $t3
	
	la $a0, s1
	li $v0, 4
	syscall
	
	jr $ra
	
