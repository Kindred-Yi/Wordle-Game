MIPS Assembly Wordle Game


Overview

This is a simplified implementation I made of the popular Wordle game, written in MIPS assembly language. The game randomly selects a 5-letter word from a predefined list, and the player has 5 attempts to guess the word.

Game Rules

1. The game starts with a welcome message and a menu to play or quit.
2. When playing, the system selects a random 5-letter word.
3. The player has 5 attempts to guess the word.
4. After each guess, the game provides feedback:
   - Letters in the correct position are shown in square brackets [X]
   - Letters in the word but in the wrong position are shown in parentheses (X)
   - Letters not in the word are shown as is
5. The game ends when the player guesses the word correctly or uses all 5 attempts.
6. After each game, the player can choose to play again or quit.

Features

- Random word selection from a list of 50+ words
- Input validation for 5-letter guesses
- Visual feedback on guess accuracy
- Option to play multiple games
- Debug mode to display the selected word (can be enabled by setting the 'debug' variable to 1)

How to Run

Load the 'wordle.asm' file into a MIPS simulator (e.g., MARS) and run the program.

Notes

- The game uses a fixed seed for random number generation to ensure reproducibility.
- The word list can be easily expanded by adding more words to the 'word_list' in the data section.
