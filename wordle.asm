.data
# Message types
debug:           .word 0
welcome_message: .asciiz "Welcome to my simple Wordle game, let's play it!\n"
menu_message:    .asciiz "What do you want to do?\n    (1) Play\n    (2) Quit\n"
line_separator:  .asciiz "="
new_line:        .asciiz "\n"
wrong_choice:    .asciiz "\nWrong choice, please choose again.\n"
make_guess:      .asciiz "\nMake your guess:"
congratulations: .asciiz "\nCongratulations! You win! The word was indeed: "
failure_message: .asciiz "\nWhoops, it seems you could not guess :(\n The word was: "
debug_mode_message: .asciiz "\nYou are in debug mode, the word system chose is:"
left_bracket:    .asciiz "["
right_bracket:   .asciiz "]"
left_parenthesis: .asciiz "("
right_parenthesis: .asciiz ")"
option_play:     .asciiz "1"
option_quit:     .asciiz "2"
seed:            .word 42

# Data types
char_array:      .space 5
player_input:    .space 5
buffer:          .space 2

# Word list
word_list:
    .asciiz "apple"
    .asciiz "baker"
    .asciiz "champ"
    .asciiz "darts"
    .asciiz "elope"
    .asciiz "flask"
    .asciiz "glint"
    .asciiz "hymns"
    .asciiz "inbox"
    .asciiz "jumps"
    .asciiz "knots"
    .asciiz "liver"
    .asciiz "mirth"
    .asciiz "nymph"
    .asciiz "oasis"
    .asciiz "pupil"
    .asciiz "quiet"
    .asciiz "ruler"
    .asciiz "slime"
    .asciiz "train"
    .asciiz "unity"
    .asciiz "vowel"
    .asciiz "wrist"
    .asciiz "xenon"
    .asciiz "youth"
    .asciiz "zebra"
    .asciiz "amber"
    .asciiz "blush"
    .asciiz "chime"
    .asciiz "demon"
    .asciiz "ember"
    .asciiz "frost"
    .asciiz "gloom"
    .asciiz "haste"
    .asciiz "inlet"
    .asciiz "joust"
    .asciiz "kiosk"
    .asciiz "ledge"
    .asciiz "mango"
    .asciiz "nexus"
    .asciiz "oasis"
    .asciiz "pupil"
    .asciiz "quota"
    .asciiz "ranch"
    .asciiz "scold"
    .asciiz "tweet"
    .asciiz "usual"
    .asciiz "venom"
    .asciiz "whisk"
    .asciiz "yodel"
    .asciiz "grape"


.text
.globl main
main:
    lw $a0, seed # Generate a random number
    li $a1, 100
    li $v0, 42
    syscall
    li $v0, 42
    syscall

    move $t0, $v0
    mul $t0, $t0, 5
game_loop:
    # Print welcome screen
    jal print_welcome

    # Decide to play or quit
    jal decide_play_or_quit

    # 5 guesses
    jal choose_word
    li $t2, 0

    addi $t0, $t0, 5 # Find the position of the next word
guess_loop:
    li $t1, 0
    la $a0, make_guess
    li $v0, 4
    syscall
    li $v0, 8
    la $a0, player_input # Get input
    li $a1, 6
    syscall
    jal check # Check if the player's guess is correct
    addi $t2, $t2, 1
    beq $t1, 5, success
    beq $t2, 5, failure
    beq $zero, 0, guess_loop

failure: # Print failure message
    la $a0, failure_message
    li $v0, 4
    syscall
    li $s0, 0
    la $s1, char_array
s_loop:
    lb $s2, ($s1)
    move $a0, $s2
    li $v0, 11
    syscall
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    blt $s0, 5, s_loop
beq $zero, 0, game_loop

success: # Print success message
    la $a0, congratulations
    li $v0, 4
    syscall
    li $s0, 0
    la $s1, char_array
ss_loop:
    lb $s2, ($s1)
    move $a0, $s2
    li $v0, 11
    syscall
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    blt $s0, 5, ss_loop
beq $zero, 0, game_loop

check:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    la $a0, new_line # New line
    li $v0, 4
    syscall

    la $s0, char_array
    la $s1, player_input
    li $s2, 0 # Counter for the first loop
loop1:
    beq $s2, 5, end_loop1
    lb $s3, ($s0)
    lb $s4, ($s1)
    bne $s3, $s4, check2
    addi $t1, $t1, 1 # Not entering check2 means same position, same letter
    la $a0, left_bracket
    li $v0, 4
    syscall
    move $a0, $s4
    li $v0, 11
    syscall
    la $a0, right_bracket
    li $v0, 4
    syscall
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    addi $s2, $s2, 1
    blt $s2, 5, loop1

end_loop1:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

check2:
    li $t7, 0 # Check if this letter also appears in the system's chosen word
    la $s6, char_array
loop2: # This loop repeats 5 times, meaning checking each letter one by one
    lb $s7, ($s6)
    beq $s4, $s7, right1 # This letter also appears in the system's chosen word, go to right1
    addi $t7, $t7, 1
    addi $s6, $s6, 1
    blt $t7, 5, loop2
move $a0, $s4
li $v0, 11
syscall
addi $s0, $s0, 1
addi $s1, $s1, 1
addi $s2, $s2, 1
beq $zero, 0, loop1

right1:
    la $a0, left_parenthesis
    li $v0, 4
    syscall
    move $a0, $s4
    li $v0, 11
    syscall
    la $a0, right_parenthesis
    li $v0, 4
    syscall
    addi $s0, $s0, 1
    addi $s1, $s1, 1
    addi $s2, $s2, 1
    beq $zero, 0, loop1

choose_word: # Choose a word from the word list
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    la $a1, word_list
    la $a2, char_array
    move $s0, $t0 # Use the number in $t0 to determine the position
    addi $s1, $s0, 5
    li $s3, 0
    lw $s4, debug
    beq $s4, 1, debug_mode
loop_for_choose_word:
    lb $s2 ($a1)
    addi $a1, $a1, 1 # Point to the next character
    addi $s3, $s3, 1
    ble $s3, $s0, loop_for_choose_word
    sb $s2, ($a2)
    beq $s4, 1, out
back:
    addi $a2, $a2, 1
    bge $s3, $s1, end_loop
    beq $zero, 0, loop_for_choose_word

end_loop:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
out:
    move $a0, $s2
    li $v0, 11
    syscall
    beq $zero, 0, back

debug_mode:
    la $a0, debug_mode_message
    li $v0, 4
    syscall
    beq $zero, 0, loop_for_choose_word

decide_play_or_quit: # Check if the player wants to continue playing
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 8
    la $a0, buffer # Load the address of the buffer into $a0
    li $a1, 2 # Read one character
    syscall

    la $s0, option_play
    la $s1, option_quit
    lb $a0, 0($s0) # Load the first character into $a0
    lb $a1, 0($s1)
    la $s3, buffer
    lb $s4, 0($s3)
    beq $s4, $a0, continue
    beq $s4, $a1, over
    la $a0, wrong_choice
    li $v0, 4
    syscall
    beq $zero, 0, decide_play_or_quit

over: # Don't want to play
    li $v0, 10
    syscall

continue: # Want to play
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

print_welcome: # Print welcome screen
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    la $a0, new_line
    li $v0, 4
    syscall

    la $a0, welcome_message
    li $v0, 4
    syscall

    # Print line "==="
    jal print_line

    la $a0, menu_message
    li $v0, 4
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

print_line: # Print line on welcome screen
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $s0, 0
    li $s1, 50
loop_start:
    la $a0, line_separator
    li $v0, 4
    syscall
    addi $s0, $s0, 1
    bne $s0, $s1, loop_start
    la $a0, new_line
    li $v0, 4
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra