	.data
s1:	.asciiz "\n"  # Hier maak ik een nieuwe string om na elke cout van een integer een newline te printen.
	
	.text
main:
	li $t1, 1 # Ik laad hier in het $t1 register de iterator
	li $t2, 11 # Hier laadt ik de maximum waarde die mijn iterator (-1 natuurlijk) mag worden.
loop:
	ble $t2, $t1, end # Hier check ik in het begin van elke loop of mijn waarde in $t1 kleiner is dan dat in $t2
	move $a0, $t1 # Ik verplaats mijn iterator in het $a0 argument register om het daarna af te printen met de juiste service.
	li $v0, 1
	syscall
	
	la $a0, s1 # Na het afprinten van de iterator print ik ook nog de newline string om ervoor te zorgen dat niet alle iterators na elkaar geprint worden.
	li $v0, 4
	addi $t1, $t1, 1
	syscall
	j loop # Hiermee ga ik terug naar het begin van loop "jump loop".
end:
	li $v0, 10 # Met de service 10, doe ik een exit.
	syscall
