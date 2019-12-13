		.data
s1:		.asciiz	"\nPlease enter a key. \n"  # Benodigde string

		.text
loop:
	li $v0, 4  # Print s1
	la $a0, s1
	syscall

	lui $t3, 0xffff  # Laadt 0xffff in $t3
	lw $t4, ($t3)  # Haal de waarde 0 of 1 uit 0xffff0000.
	
	li $v0, 32  # Dit zorgt voor een 2 seconden sleep zodat elke loop een delay heeft van 2 seconden (wegens performantie problemen kan een lagere waarde zoals bv 200 beter zijn)
	li $a0, 2000
	syscall
	
	beq $t4, 1, printChar  # Check of er een character is ingegeven, zo ja: ga naar printChar en print het character.
	
	j loop

printChar:
	lw $a0, 4($t3)  # Laadt de waarde van 0xffff0004 in $a0 (het ingegeven character)
	li $v0, 11 # Met de opcode 11 print je de char uit.
	syscall	
	
	j loop	# Ga terug naar het begin van de loop.
