	.data
s1: 	.asciiz "Geef een straal: \n" # De benodigde strings & een float met de waarde van PI.
s2:	.asciiz	"De oppervlakte van deze cirkel is: "  
pi:	.float 3.14159265359

	.text
main:
	la $a0, s1 # Hier print ik string s1.
	li $v0, 4
	syscall
	
	li $v0, 6 # Ik read hier een float.
	syscall
	mov.s $f1, $f0  # Deze float verplaats ik naar register $f1.
	
	lwc1 $f2, pi # PI zet ik in het floating point register $f2.
	mul.s $f3, $f1, $f1 # Ik bereken de oppervlakte met mul.s (multiply).
	mul.s $f4, $f3, $f2
	
	la $a0, s2 # Ik print string s2.
	li $v0, 4
	syscall
	
	mov.s $f12, $f4 # Ik verplaats het resultaat naar floating point register $f12 en print het uit.
	li $v0, 2
	syscall
	
	