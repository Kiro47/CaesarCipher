#Name: __STRIPPED__
#Username: __STRIPPED__
#Description: This program performs a Caesar Cipher of specified shifting on capital letters of words.
#email: __STRIPPED__
#DateCreated: 10-04-16
#DateLastRevised: 10-08-16

##########################################
#Begin
##########################################
##### Variable Directory
### $t8 and $t9 are only used in pre-proccessing
# $t9 = byte counter
### Used throughought the main part of the program
# $t7 = amount to shift by
# $t6 = Pointer to the address to perform on next
# $t5 = The next word to be changed
# $t4 = Lowest value of capital ASCII chars
# $t3 = Highest value of capital ASCII chars
# $t0 = byte to handle
main:
	b reset

######################################
# Iterate over the characters in a word 
# and check if they're capital
# if they are, shift; then store in memory
######################################
iterateOver:
	lb $a0, 0($t6) # Load character of the word
	beq $a0, 0, nextWord # Ending of structure
	jal checkHigh # Jump to check character and link

	li $v0, 11 #Call command to output char
	syscall # Outputs char in #a0

	add $t6, $t6, 1 # increment to next byte

	b iterateOver # loop de loop
#####################################
# Ends the current word
#####################################
finishWord:
	lb $a0, 0($t6) # Load the next letter
	beq $a0, 0, exit # Exit the system

	jal checkHigh #Iterates over the final word

	li $v0, 11 # Prep out command for $a0
	syscall #output character

	add $t6, $t6, 1 # Move on to the next

	b finishWord # loop de loop
#####################################
# Check to see if character is in range
#####################################
checkHigh: 
	ble $a0, 90, checkLow # Char falls into bounds, crypt shift it
	jr $ra # Return to jal in iterateOver
#####################################
# Check to see if character is in range
#####################################
checkLow:
	bge $a0, 65, crypt # Char falls into bounds, crypt shift it
	jr $ra # Return to jal in iterateOver
#####################################
# Lowers character until within range
#####################################
crypt:
	add $a0, $a0, $t9 # Add in shift
	bgt $a0, 90, lowerCharacter # If too high out of range, wrap
	blt $a0, 65, raiseCharacter # If too low out of range, wrap
	jr $ra # Jump back to iterateOver jal
#####################################
# Lowers character until within range
#####################################
lowerCharacter:
	sub $a0, $a0, 26 # Subtract 26 to put back in range, EX: Z + shift of right 1 = dec(91). 91 - 26 = 65 (ASCII 'A')
	#bgt $t0, $t3 , lowerCharacter #Used to wrap characters around to 'A' if they exceed the level
	jr $ra # Jump back to iterateOver jal
#####################################
# Raises character until within range
#####################################
raiseCharacter:
	add $a0, $a0, 26 # Add 26 to put back in range, EX: A + shift of left 1 = dec(64). 64 + 26 = 90 (ASCII 'Z')
	#blt $t0, $t4 , raiseCharacter #Used to wrap characters around to 'Z' if they are below the level
	jr $ra  # Jump back to iterateOver jal
#####################################
# Jump to next word
#####################################
nextWord:
	lw $t5, 0($t7) # to next
	beq $t5, -1 finishWord # Permits start of end sequence

	lw $t8, 0($t7) # Load node word
	la $t7, 0($t8) # load next address
	la $t6, 4($t8) # load next node word address
	lw $t5, 0($t8) # to next

	li $v0, 11 #Syscall, 11 to print out
	addi $a0, $0, 32 # ASCII Space
	syscall # Push out space character

	beq $t5, -1 finishWord # Permits start of end sequence

	j iterateOver # Go to iterateOver and start scanning


######################################
# Exits the program
######################################
exit:
	li $v0, 10 # Loads exit code to be called
	syscall # Issue system call to terminate program
######################################
# Reset all active used value to zero
######################################
reset:
	###########
	li $a0, 0 # Set all arguments as 0
	li $a1, 0
	li $a2, 0
	li $a3, 0
	########### Set All temp var values as 0
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	########### Set All saved var values as 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	# Start the main portion of the program
	b preset

######################################
# Set up Enviroment
######################################
preset:
	lw $t9, shift # Amount to peform binary shifts to and from
	la $t8, first # Address pointer Node
	la $t7, 0($t8) # Load word
	la $t6, 4($t8) # Load message

	beq $t7, -1, finishWord

	b iterateOver #Finds the point to start saving encrypted chars


### START DATA ###
.data
shift:  .word 3
first:  .word -1
### END DATA ###

