		.data
filename:	.asciiz" < pad naar de input.txt file > /input.txt" # De benodigde filename, zorg ervoor dat deze string, of bij de jar file van MARS zit, of het volledige pad in de string komt.
buffer:		.space	1024  # Voor de inhoud van de input.txt file maak ik ruimte vrij met .space

		.text
main:
	li $v0, 13  # Met de opcode 13 wordt de file geopend.
	la $a0, filename
	syscall
	
	move $s0, $v0  # Save de file descriptor.
	
	li   $v0, 14  # Met de opcode 14 lezen we de inhoud van deze file descriptor.
	move $a0, $s0  # De file descriptor wordt in het argument register geladen.
	la   $a1, buffer # Hier geef ik als tweede argument de buffer (space v/ 1024 bytes) mee.
	li   $a2, 1024  # Als derde argument geef ik de hardcoded buffer length mee.
	syscall
	
	li $v0, 4  # Ten laatste print ik de inhoud van de .txt-file.
	la  $a0, buffer
	syscall
	
	li $v0, 10  # Het programma wordt beëindigd.
	syscall
