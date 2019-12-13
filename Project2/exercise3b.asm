		.data
s1:		.asciiz	"\n"  # De benodigde strings.
up:		.asciiz "Up"
down: 		.asciiz "Down"
left:		.asciiz "Left"
right:		.asciiz "Right"

		.text
loop:
	li $v0, 4  # Dit is een niet stoppende loop die om de 200 miliseconden gaat checken of er een character is ingegeven.
	la $a0, s1  # "\n" wordt geprint.
	syscall

	lui $t3, 0xffff  # De 0xffff wordt geladen in $t3.
	lw $t4, ($t3)  # De waarde van 0xffff0000 wordt in $t4 geladen.
	
	li $v0, 32  # 200 milisecond delay.
	li $a0, 200
	syscall
	
	beq $t4, 1, checkChar  # Als er zich in $t4 een 1 bevindt zal er gecheckt worden welk character dit was.
	
	j loop  # Er wordt terug naar het begin van de loop gesprongen.

checkChar:
	lw $t5, 4($t3)  # checkChar zal eerst de waarde van 0xffff0004 in $t5 laden.
	
	# Hieronder zal gecheckt worden of dit character gelijk is aan de mogelijke: z,q,s,d, x. Zo ja: ga naar het juiste print/end Label.
	beq $t5, 'z', printUp
	beq $t5,  's', printDown
	beq $t5, 'q',printLeft
	beq $t5, 'd', printRight
	beq $t5, 'x', quit
	
	j loop # Gaat terug naar het begin van de loop.
printUp:
	la $a0, up  # Er wordt "Up" geprint.
	li $v0, 4
	syscall	
	
	j loop  # Springt terug naar de loop.
	
printDown:
	la $a0, down  # Print "Down".
	li $v0, 4
	syscall	
	
	j loop # Springt terug naar de loop.
	
printLeft:
	la $a0, left  # Print "Left".
	li $v0, 4
	syscall	
	
	j loop  # Springt terug naar de loop.

printRight:
	la $a0, right  # Print "Right".
	li $v0, 4
	syscall	
	
	j loop  # Springt terug naar de loop.
	
quit:
	li $v0, 10  # Beëindigd het programma. 
	syscall
