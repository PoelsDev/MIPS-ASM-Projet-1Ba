	.data
s1:	.asciiz "Geef een integer(>0):\n"  # Hier maak ik enkele strings voor gebruik in het .text-segment.
s2:	.asciiz " "
s3: 	.asciiz "\n"

	.text
main:
	la $a0, s1  # Ik print string s1.
	li $v0, 4
	syscall
	
	li $v0, 5  # Hier read ik een integer.
	syscall
	move $t0, $v0 # Deze integer verplaats ik naar het $t0 register.
	
	li $t1, 1 # Ik maak een iterator voor mijn eerste loop.
	li $t2, 1 # Dit is de iterator voor mijn tweede loop.
	
loop1:
	bgt $t1, $t0, end1 # Ik check of $t1 groter is dan $t0, zo ja dan ga ik naar end1, anders voer ik de loop uit.
	
	la $a0, s3  # Ik print s3 (newline)
	li $v0, 4
	syscall
loop2:
	bgt $t2, $t1, end2  # In mijn tweede loop, loop ik over de elementen tussen mijn eerste en tweede iterator.
	move $a0, $t2  # Ik print de tweede iterator uit.
	li $v0, 1
	syscall
		
	la $a0, s2 # Hier print ik een spatie voor tussen de integers van de piramide.
	li $v0, 4
	syscall
		
	addi $t2, $t2, 1 # Ik verhoog mijn tweede iterator.
	j loop2 # Hier spring ik terug naar het begin van de loop.
end2:
	li $t2, 1 # Hier zet ik de tweede iterator terug op 1.
	addi $t1, $t1, 1 # Ik verhoog de 1ste iterator met 1.
	j loop1
end1:
	li $v0, 10 # Ik beëindig het programma.
	syscall
		