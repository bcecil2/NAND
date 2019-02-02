// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

(SETUP)

@product //stores the final result
M=0

@R2 //sets R2 to zero 
M=0


// storing R0 into variable a to be used in loop
@R0 
D=M
@a 
M=D

// storing R1 into variable i to be used as loop counter
@R1
D=M
@i
M=D

(LOOP)

// if i == 0 jump to end
@i
D=M
@END
D;JEQ

// product += a
@a  
D=M
@product 
M=D+M 

// i = i - 1
@i
M=M-1 
@LOOP
0;JMP

(END)
//store the result of product in R2
@product
D=M
@R2
M=D

(THEREALEND)
@THEREALEND
0;JMP
