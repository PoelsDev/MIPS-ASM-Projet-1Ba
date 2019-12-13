		.data
filename:	.asciiz "/home/thibaultpoels/Documents/UA/Computersystemen_architectuur/Taken/Taak_MIPS/Project3/input.txt"  # !!! absoluut pad naar de file !!!
buffer:		.space 1024
yellow: 	.word 0x00ffff00
blue:		.word 0x000000ff
black:		.word 0x00000000
green:		.word 0x0000ff00
red:		.word 0x00ff0000
white:		.word 0x00ffffff

		.text
main:
	jal createMaze
	move $s0, $v0
	move $s1, $v1
	
	move $a0, $s0
	li $v0, 1
	syscall
	
	move $a0, $s1
	li $v0, 1
	syscall
	
	jal getPlayerStartPos
	
	move $s2, $v0
	move $s3, $v1
	
	move $a0, $s2
	li $v0, 1
	syscall
	
	move $a0, $s3
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall

createMaze:
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 16	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# save locally used registers
	sw	$s1, -12($fp)
	
	li $v0, 13  # Met de opcode 13 wordt de file geopend.
	la $a0, filename
	syscall
	
	move $s0, $v0  # Save de file descriptor.

	li   $v0, 14  # Met de opcode 14 lezen we de inhoud van deze file descriptor.
	move $a0, $s0  # De file descriptor wordt in het argument register geladen.
	la   $a1, buffer # Hier geef ik als tweede argument de buffer (space v/ 1024 bytes) mee.
	li   $a2, 72 # Als derde argument geef ik de hardcoded buffer length mee.
	syscall

	la $a0, buffer
	jal checkChars
	
	move $v0, $v0
	move $v1, $v1
	
	lw	$s1, -12($fp)	# reset saved register $s1
	lw	$s0, -8($fp)	# reset saved register $s0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old stack pointer from current frame pointer
	lw	$fp, ($sp)	# restore old frame pointer
	j done
	
checkChars:
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 28	# allocate 28 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# save locally used registers
	sw	$s1, -12($fp)
	sw 	$s2, -16($fp)
	sw 	$s3, -20($fp)
	sw 	$s4, -24($fp)
	
	li $v0, 13  # Met de opcode 13 wordt de file geopend.
	la $a0, filename
	syscall
	
	move $s0, $v0  # Save de file descriptor.
	li   $v0, 14  # Met de opcode 14 lezen we de inhoud van deze file descriptor.
	move $a0, $s0  # De file descriptor wordt in het argument register geladen.
	la   $a1, buffer # Hier geef ik als tweede argument de buffer (space v/ 1024 bytes) mee.
	li   $a2, 73 # Als derde argument geef ik de hardcoded buffer length mee.
	syscall

	li $s2, 0
	li $s1, 1
	li $s3, 0
	li $t1, 0
	
	jal charLoop
	
	move $v0, $s3
	move $v1, $s1
	
	lw 	$s4, -24($fp)
	lw 	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)	# reset saved register $s1
	lw	$s0, -8($fp)	# reset saved register $s0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old stack pointer from current frame pointer
	lw	$fp, ($sp)	# restore old frame pointer
	j done

charLoop:
	beq $s2, 73, done
	lb $a0, buffer($s2)
	addi $s2, $s2, 1
	beq $a0, '\n', addYandDefineX
	
	li $v0, 11
	syscall
	
	move $t0, $zero
	add $t0, $gp, $t1
	addi $t1, $t1, 4
	
	beq $a0, 'w', toBlue
	beq $a0, 'p', toBlack
	beq $a0, 's', toYellow
	beq $a0, 'u', toGreen
	beq $a0, 'e', toRed
	beq $a0, 'c', toWhite
	
	j charLoop
	
toYellow:
	lw $t2, yellow
	sw $t2, ($t0)
	j charLoop

toGreen:
	lw $t2, green
	sw $t2, ($t0)
	j charLoop

toBlack:
	lw $t2, black
	sw $t2, ($t0)
	j charLoop
	
toBlue:
	lw $t2, blue
	sw $t2, ($t0)
	j charLoop
	
toWhite: 
	lw $t2, white
	sw $t2, ($t0)
	j charLoop
	
toRed:
	lw $t2, red
	sw $t2, ($t0)
	j charLoop
	
addYandDefineX:
	beq $s1, 1, defineX
	addi $s1, $s1, 1
	j charLoop
	
defineX:
	move $s3, $s2
	subi $s3, $s3, 1
	addi $s1, $s1, 1
	j charLoop
	
done:
	jr $ra
	
calculateAddress:
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 20	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# save locally used registers
	sw	$s1, -12($fp)
	sw 	$s2, -16($fp)
	
	mul $t3, $a1, $a0 # Bereken de nieuwe coördinaat. (adres = (32 * x) + y)
	add $t3, $t3, $a2
	mul $t3, $t3, 4   # Bereken de weldegelijke coördinaat door het resultaat van hierboven *4 te doen en daarna dit bij $gp op te tellen.
	add $t4, $gp, $t3
	
	move $v0, $t4
	
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)	# reset saved register $s1
	lw	$s0, -8($fp)	# reset saved register $s0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old stack pointer from current frame pointer
	lw	$fp, ($sp)	# restore old frame pointer
	j done
	
getPlayerStartPos:
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 16	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# save locally used registers
	sw	$s1, -12($fp)
	
	li $v0, 13  # Met de opcode 13 wordt de file geopend.
	la $a0, filename
	syscall
	
	move $s0, $v0  # Save de file descriptor.

	li   $v0, 14  # Met de opcode 14 lezen we de inhoud van deze file descriptor.
	move $a0, $s0  # De file descriptor wordt in het argument register geladen.
	la   $a1, buffer # Hier geef ik als tweede argument de buffer (space v/ 1024 bytes) mee.
	li   $a2, 72 # Als derde argument geef ik de hardcoded buffer length mee.
	syscall
	
	li $t0, 0
	li $t1, 0
	li $t3, 0
	
	jal playerLoop
	
	addi $t4, $t1, 1
	div $t0, $t4
	mflo $t3
	sub $t3, $t3, 2
	
	move $v0, $t3
	move $v1, $t1
	
	lw	$s1, -12($fp)	# reset saved register $s1
	lw	$s0, -8($fp)	# reset saved register $s0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old stack pointer from current frame pointer
	lw	$fp, ($sp)	# restore old frame pointer
	j done

playerLoop:
	beq $t0 72, done
	lb $a0, buffer($t0)
	addi $t0, $t0, 1
	beq $a0, '\n', addY
	beq $a0, 's', done
	
	j playerLoop
	
addY:
	addi $t1, $t1, 1
	j playerLoop