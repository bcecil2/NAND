// This file is part of www.nand2tetris.org
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

//initialize current pixel to point at base of screen memory
@SCREEN
D=A
@currentpixel
M=D
//initalize constant to address of last screen pixel
@KBD
D=A
@lastpixel
M=D
//infinite loop that listens for keyboard input
(INFLOOP)

// check keyboard if key pressed jump to make pixel 

@KBD
D=M
@MAKEPIXEL
D;JNE

// else jump to delete pixel

@DELETEPIXEL
0;JMP


(MAKEPIXEL)
// checks to see if index is in valid range by doing lastpixel - currentpixel
@currentpixel
D=M
@lastpixel
D=D-M

// if d == 0 we have an invalid index and are done
@INFLOOP
D;JEQ

// else get the address of the current pixel, set to black, then increment
@currentpixel
A=M
M=-1
@currentpixel
M=M+1

// check to see if key is still being pressed
@INFLOOP
0;JMP

(DELETEPIXEL)
// check to see if index is valid by doing currentpixel - SCREEN
@SCREEN
D=A
@currentpixel
D=M-D

// if d < 0 we have and invalid index and are done
@INFLOOP
D;JLT

// else get the address of the current pixel, set to white, then increment
@currentpixel
A=M
M=0
@currentpixel
M=M-1

// check to see if no key is being pressed
@INFLOOP
0;JMP
