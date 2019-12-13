	.data     # Dit is het data-segment, het bevat de twee strings die ik nodig heb.
s1:	.asciiz "This is my "
s2:	.asciiz "-th mips program.\n"

	.text     # Dit is het text-segment waarin ik de code heb geschreven voor het programma.
main:
	li $v0, 5 # Hier roep ik van register $v0 de read_int service aan.
	syscall
	move $t0, $v0 # Hiervan steek ik het resultaat in register $t0.
	
	la $a0, s1 # Hier laadt ik mijn eerste string in een argument register.
	li $v0, 4  # Ik gebruik de print_string service van register $v0 en print $a0 waarin mijn string is geladen.
	syscall
	
	move $a0, $t0 # Dit doe ik opnieuw maar voor de integer die ik bij het eerste deel van mijn code heb ingelezen.
	li $v0, 1
	syscall
	
	la $a0, s2 # Tenslotte doe ik dit nog voor mijn laatste string.
	li $v0, 4
	syscall
