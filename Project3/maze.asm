# Naam: Thibault Poels
# ID:	20192112
# Uitleg: De meegevoerde input-file heeft een grote van 136 characters (dit is ook zo in de loops/buffer length ingesteld). De input-file werkt met de bitmap waardes (32,32,512,256).
# Er is ook gebruik gemaakt van een absoluut pad. (AANPASSING NODIG)
		.data
filename:	.asciiz "/home/thibaultpoels/Documents/UA/Computersystemen_architectuur/Taken/Taak_MIPS/Project3/input2.txt"  # !!! ABSOLUUT PAD NAAR DE INPUT FILE !!!
# Buffer voor file
buffer:		.space 1024
# Gebruikte kleuren
yellow: 	.word 0x00ffff00
blue:		.word 0x000000ff
black:		.word 0x00000000
green:		.word 0x0000ff00
red:		.word 0x00ff0000
white:		.word 0x00ffffff

		.text
##################################### MAIN ########################################
main:
	jal createMaze 		# Dit maakt de maze.
	
	jal getPlayerStartPos 	# De startpositie van de player wordt gezocht en teruggegeven.
	
	move $a0, $v0 		# De x & y waarde van de startpositie worden in de argument registers gezet voor de main game loop
	move $a1, $v1
	
	jal mainGameLoop
		
	li $v0, 10 		# Einde van het programma (nooit bereikt - enkel voor het geval van problemen)
	syscall
##################################################################################
# Twee simpele functies zonder framestack nodig.
done:
	jr $ra
	
quit:
	li $v0, 10
	syscall
##################################################################################
createMaze:
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 28	# allocate 28 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# save locally used registers
	sw	$s1, -12($fp)
	sw 	$s2, -16($fp)
	sw 	$s3, -20($fp)
	sw 	$s4, -24($fp)
	
	li $v0, 13  		# Met de opcode 13 wordt de file geopend.
	la $a0, filename
	syscall
	
	move $s0, $v0  		# Save de file descriptor.
	li   $v0, 14  		# Met de opcode 14 lezen we de inhoud van deze file descriptor.
	move $a0, $s0  		# De file descriptor wordt in het argument register geladen.
	la   $a1, buffer 	# Hier geef ik als tweede argument de buffer (space v/ 1024 bytes) mee.
	li   $a2, 136 		# Als derde argument geef ik de HARDCODED buffer length mee. - HARDCODED MAZE SIZE (AANPASSEN IN GEVAL VAN NIEUWE MAZE)
	syscall

	li $s2, 0 		# Dit zijn enkele iterators & andere tellers die ik op voorhand op 0 zet.
	li $s1, 0
	li $s3, 0
	li $t1, 0
	
	jal charLoop 		# Er wordt geloopt over de input.
	
	move $v0, $s3
	move $v1, $s1
	
	lw 	$s4, -24($fp)
	lw 	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)	# reset saved registers
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old stack pointer from current frame pointer
	lw	$fp, ($sp)	# restore old frame pointer
	j done

charLoop:
	beq $s2, 136, done 	# Loop over de input file - HARDCODED MAZE SIZE (AANPASSEN IN GEVAL VAN ANDERE INPUT)
	lb $a0, buffer($s2) 	# Laadt in $a0 het character (met offset $s2)
	beq $a0, '\n', skip 	# Sla de \n characters over.
	
	#li $v0, 11
	#syscall
	
	addi $s2, $s2, 1 	# Verhoog de iterator
	
	move $t0, $zero 	# zet in $t0, 0
	add $t0, $gp, $t1 	# zet in $t0, $gp (address van de eerste pixel in de bitmap) + $t1
	addi $t1, $t1, 4 	# verhoog de teller $t1 met 4 (voor de volgende pixel)
	
	# If statements die de juiste kleur toepassen in het true-geval.
	beq $a0, 'w', toBlue
	beq $a0, 'p', toBlack
	beq $a0, 's', toYellow
	beq $a0, 'u', toGreen
	beq $a0, 'e', toRed
	beq $a0, 'c', toWhite
	
	j charLoop 		# jump naar het begin van de loop
	
# Deze simpele labels veranderen niets aan de $s-registers en passen enkel een kleur toe aan het adres in $t0, daarna jumpen ze terug naar het begin van de loop.
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

skip:
	addi $s2, $s2, 1
	j charLoop
	
##################################################################################
	
##################################################################################
# $a0: maze x-size
# $a1: player x
# $a2: player y
calculateAddress:
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 8	# allocate 8 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	
	mul $t3, $a2, $a0 	# Bereken de nieuwe coördinaat. (adres = (maze x-size * y) + x)
	add $t3, $t3, $a1
	mul $t3, $t3, 4   	# Bereken de weldegelijke coördinaat door het resultaat van hierboven *4 te doen en daarna dit bij $gp op te tellen.
	add $t4, $gp, $t3
	
	move $v0, $t4 		# plaats het adres in de return register
	
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old stack pointer from current frame pointer
	lw	$fp, ($sp)	# restore old frame pointer
	j done
##################################################################################
	
##################################################################################	
getPlayerStartPos:
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 16	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# save locally used registers
	sw	$s1, -12($fp)
	
	li $v0, 13  		# Met de opcode 13 wordt de file geopend.
	la $a0, filename
	syscall
	
	move $s0, $v0  		# Save de file descriptor.

	li   $v0, 14  		# Met de opcode 14 lezen we de inhoud van deze file descriptor.
	move $a0, $s0  		# De file descriptor wordt in het argument register geladen.
	la   $a1, buffer	# Hier geef ik als tweede argument de buffer (space v/ 1024 bytes) mee.
	li   $a2, 136 		# Als derde argument geef ik de hardcoded buffer length mee.
	syscall
	
	li $t0, 0 		# Enkele iterators voor de startPositionLoop
	li $t1, 0
	li $t3, 0
	
	move $t4, $zero		# idem, maar op een andere manier
	
	jal startPositionLoop
	
	sub $t4, $t4, 1		# De x teller zal altijd 1 te ver staan, daarom wordt die met 1 verlaagd.
	move $v0, $t4		# De x waarde wordt in het eerste return register gezet.
	move $v1, $t1		# De y waarde wordt in het tweede return register gezet.
	
	lw	$s1, -12($fp)	# reset saved register $s1
	lw	$s0, -8($fp)	# reset saved register $s0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old stack pointer from current frame pointer
	lw	$fp, ($sp)	# restore old frame pointer
	j done

startPositionLoop:
	beq $t0, 136, done 	# Loop die itereert tot de positie van "s" in de input file. (HARDCODED MAZE SIZE: AANPASSEN AAN INPUT FILE)
	lb $a0, buffer($t0) 	# Laadt in $a0 het character (met offset $t0)
	addi $t0, $t0, 1	# Verhoog de y teller
	addi $t4, $t4, 1	# Verhoog de x teller
	beq $a0, '\n', addY	# Verhoog de weldegelijke y waarde
	beq $a0, 's', done
	
	j startPositionLoop
	
addY:
	move $t4, $zero 	# Zet de x-waarde weer op 0
	addi $t1, $t1, 1	# Verhoog de y waarde met 1
	j startPositionLoop	# Spring terug naar het begin van de loop
##################################################################################

##################################################################################
# $a0: player old x
# $a1: player old y
# $a2: player new x
# $a3: player new y

playerUpdate:
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 24	# allocate 24 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)
	sw	$s1, -12($fp)
	sw	$s2, -16($fp)
	sw	$s3, -20($fp)
	
	move $s0, $a0		# De nieuwe/oude x waardes worden al meteen verplaatst naar een $saved register.
	move $s1, $a1
	move $s2, $a2
	move $s3, $a3
	
	jal getMazeSize		# De maze size wordt hier opgevraagd en verplaatst in het eerste $argument register, daarnaast worden de nieuwe posities in de tweede en derde $a register geplaatst.
	
	move $a0, $v0
	move $a1, $s2
	move $a2, $s3
	
	jal calculateAddress 	# Het adres van het nieuwe adres wordt berekend.
	
	move $t0, $v0		# Het adres wordt verplaatst naar $t0.
	lw $t1, ($t0)		# De kleur van dit adres wordt geladen, daarnaast ook de kleur zwart & groen.
	lw $t2, black
	lw $t5, green
	
	beq $t1, $t2, newPosition	# Als de nieuwe positie de kleur zwart bevat wordt de player verpaatst naar deze positie.
	beq $t1, $t5, endGame		# In het geval van de groene kleur wordt het spel beëindigd.
	
	move $v0, $s0		# De nieuwe huidige positie wordt gereturnt.
	move $v1, $s1
	
	lw	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)	# reset locally saved registers
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old stack pointer from current frame pointer
	lw	$fp, ($sp)	# restore old frame pointer
	
	j done
	
newPosition:
# In dit label dat zich in dezelfde subroutine bevindt zal de kleur verplaatsen en de subroutine op de juiste manier beëindigen.
	lw $t3, yellow		# Op de nieuwe positie wordt de kleur geel geplaatst.
	sw $t3, ($t0)		
	
	move $a1, $s0		# Het adres van de oude positie wordt berekend.
	move $a2, $s1
	jal calculateAddress
	
	lw $t3, black		# Op dit adres wordt zwart geplaatst.
	sw $t3, ($v0)
	
	move $v0, $s2		# In de return waardes wordt de nieuwe positie geplaatst en gereturned.
	move $v1, $s3

	lw	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)	# reset locally saved registers
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old stack pointer from current frame pointer
	lw	$fp, ($sp)
	
	j done
	
endGame:
# Dit label dat zich ook bevindt in de updatePlayer subroutine doet exact hetzelfde als het newPosition label maar zal niet naar het return adres springen, het zal het spel beëindigen.
	lw $t3, yellow
	sw $t3, ($t0)
	
	move $a1, $s0
	move $a2, $s1
	jal calculateAddress
	
	lw $t3, black
	sw $t3, ($v0)
	
	move $v0, $s2
	move $v1, $s3

	lw	$s3, -20($fp)
	lw	$s2, -16($fp)
	lw	$s1, -12($fp)
	lw	$s0, -8($fp)	# reset locally saved registers
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old stack pointer from current frame pointer
	lw	$fp, ($sp)
	
	j quit
	
##################################################################################

##################################################################################
getMazeSize:
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 12	# allocate 12 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)
	
	li $v0, 13  		# Met de opcode 13 wordt de file geopend.
	la $a0, filename
	syscall
	
	move $s0, $v0  		# Save de file descriptor.
	li   $v0, 14  		# Met de opcode 14 lezen we de inhoud van deze file descriptor.
	move $a0, $s0  		# De file descriptor wordt in het argument register geladen.
	la   $a1, buffer 	# Hier geef ik als tweede argument de buffer (space v/ 1024 bytes) mee.
	li   $a2, 136		# Als derde argument geef ik de hardcoded buffer length mee. (HARDCODED MAZE SIZE: AANPASSEN in geval van nieuwe input)
	syscall
	
	move $t0, $zero		# Iterator/teller krijgt een beginwaarde.
	move $t1, $zero
	
	jal sizeLoop		# Start van de loop die de size telt.
	
	move $v0, $t2		# De x-waarde van de maze wordt in een return register geplaatst.
	move $v1, $t1		# De y-waarde van de maze wordt in een return register geplaatst.

	lw	$s0, -8($fp)	
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old stack pointer from current frame pointer
	lw	$fp, ($sp)	# restore old frame pointer
	j done
	
sizeLoop:
	beq $t0, 136, done	# HARDCODED MAZE SIZE: aanpassen bij nieuwe input file
	lb $a0, buffer($t0)	# Laadt het character (met offset $t0) uit de buffer
	beq $a0, '\n', getY	# getY wordt bij elke newline uitgevoerd.
	addi $t0, $t0, 1	# de iterator wordt verhoogd.
	
	j sizeLoop		# springt naar het begin van de loop.
	
getY:
	beq $t1, $zero, getX	# Als de loop net is gestart zal de x waarde 1 maal worden vastgelegd.
	addi $t1, $t1, 1	# De y waarde wordt verhoogd.
	addi $t0, $t0, 1	# De iterator wordt verhoogd. (x)
	j sizeLoop		# springt terug naar het begin van de loop.

getX:
	move $t2, $t0		# Verplaatst in $t2 de huidige iterator waarde (op dat moment in de loop zal dit de juiste x size zijn)
	addi $t1, $t1, 1	# Verhoog de y waarde
	addi $t0, $t0, 1	# Verhoog de iterator (x)
	j sizeLoop		# Springt terug naar het begin van de loop.
##################################################################################

################################ MAIN GAME LOOP ##################################
mainGameLoop:
	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 16	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	sw	$s0, -8($fp)	# x
	sw 	$s1, -12($fp)	# y
	
	move $s0, $a0		# De start x & y waardes worden in $s registers opgeslagen.
	move $s1, $a1
	
inputLoop:			# Deze loop checkt of er een nieuwe input is en zal dan acties uitvoeren.
	lui $t3, 0xffff  	# De 0xffff wordt geladen in $t3.
	lw $t4, ($t3)  		# De waarde van 0xffff0000 wordt in $t4 geladen.
	
	li $v0, 32 		# 60 milisecond delay.
	li $a0, 60
	syscall
	
	beq $t4, 1, checkChar  	# Als er zich in $t4 een 1 bevindt zal er gecheckt worden welk character dit was.
	
	j inputLoop  		# Er wordt terug naar het begin van de loop gesprongen.
	
checkChar:
	lw $t5, 4($t3)  # checkChar zal eerst de waarde van 0xffff0004 in $t5 laden.
	
	# Hieronder zal gecheckt worden of dit character gelijk is aan de mogelijke: z,q,s,d. Zo ja: ga naar het juiste label.
	beq $t5, 'z', Up
	beq $t5,  's', Down
	beq $t5, 'q', Left
	beq $t5, 'd', Right
	
	j inputLoop # Gaat terug naar het begin van de loop.
Up:	
	# Hieronder wordt de oude/nieuwe positie verplaatst in de argument registers (met een aanpassing op basis van de beweging).
	move $a0, $s0
	move $a1, $s1
	subi $t1, $s1, 1
	move $a2, $s0
	move $a3, $t1
	
	jal playerUpdate	# De positie wordt geupdate.
	
	move $s0, $v0		# De nieuwe positie wordt in de "huidige positie" registers geplaatst.
	move $s1, $v1
	
	j inputLoop  # Springt terug naar de loop.
	
Down:	
	# Zie het "Up" label voor uitleg ==> dit is heel analoog (1 verschil en dat is de aanpassing van de nieuwe positie: deze is op basis van de beweging).
	move $a0, $s0
	move $a1, $s1
	addi $t1, $s1, 1
	move $a2, $s0
	move $a3, $t1
	
	jal playerUpdate
	
	move $s0, $v0
	move $s1, $v1
	
	j inputLoop # Springt terug naar de loop.
	
Left:	
	# Zie het "Up" label voor uitleg ==> dit is heel analoog (1 verschil en dat is de aanpassing van de nieuwe positie: deze is op basis van de beweging).
	move $a0, $s0
	move $a1, $s1
	subi $t1, $s0, 1
	move $a2, $t1
	move $a3, $s1
	
	jal playerUpdate
	
	move $s0, $v0
	move $s1, $v1
	
	j inputLoop  # Springt terug naar de loop.

Right:
	# Zie het "Up" label voor uitleg ==> dit is heel analoog (1 verschil en dat is de aanpassing van de nieuwe positie: deze is op basis van de beweging).
	move $a0, $s0
	move $a1, $s1
	addi $t1, $s0, 1
	move $a2, $t1
	move $a3, $s1
	
	jal playerUpdate
	
	move $s0, $v0
	move $s1, $v1
	
	j inputLoop  # Springt terug naar de loop.
	
	lw 	$s1, -12($fp)	# y
	lw	$s0, -8($fp)	# x
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old stack pointer from current frame pointer
	lw	$fp, ($sp)	# restore old frame pointer
##################################################################################
