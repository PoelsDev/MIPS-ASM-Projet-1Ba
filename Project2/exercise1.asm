	.data
x:	.asciiz "x: "  # Nodige strings
y:	.asciiz "y: "
co:	.asciiz "Coordinate: "
	
	.text
main:
	la $a0, x  # Print x
	li $v0, 4
	syscall
	
	li $v0, 5  # Vraag naar x
	syscall
	move $t0, $v0
	
	la $a0, y  # Print y
	li $v0, 4
	syscall
	
	li $v0, 5  # Vraag naar y
	syscall
	move $t1, $v0
	
calculateAddress:
	mul $t3, $t0, 32  # Bereken de nieuwe coördinaat. (adres = (32 * x) + y)
	add $t3, $t3, $t1
	mul $t3, $t3, 4   # Bereken de weldegelijke coördinaat door het resultaat van hierboven *4 te doen en daarna dit bij $gp op te tellen.
	add $t4, $gp, $t3
	
	la $a0, co  # Print co
	li $v0, 4
	syscall
	
	move $a0, $t4  # Print de coördinaat van de ingegeven x & y.
	li $v0, 1
	syscall
	
	li $v0, 10  # Beëindig het programma.
	syscall
	