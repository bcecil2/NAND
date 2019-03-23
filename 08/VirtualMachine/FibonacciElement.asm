@256
D=A
@SP
M=D
@Sys.init
0;JMP//function Main.fibonacci 0

(Main.fibonacci)
//push argument 0

@0
D=A
@ARG

M=M+D
A=M
D=M 
@SP
A=M
M=D
@0
D=A
@ARG

M=M-D
@SP
M=M+1
//push constant 2

@2
D=A
@SP

A=M
M=D
@SP
M=M+1

//lt                     // checks if n<2

@SP
M=M-1
@SP
A=M
D=M
@SP
M=M-1
A=M
D=M-D
@TRUECASE1
D;JLT
@NOTTRUECASE1
0;JMP
(TRUECASE1)
@SP
A=M
M=-1
@CHANGESP1
0;JMP
(NOTTRUECASE1)
@SP
A=M
M=0
(CHANGESP1)
@SP
M=M+1
 //if-goto IF_TRUE

@SP
M=M-1
A=M
D=M
@$IF_TRUE
D;JNE

//goto IF_FALSE

@$IF_FALSE
0;JMP
//label IF_TRUE          // if n<2, return n

($IF_TRUE)
//push argument 0        

@0
D=A
@ARG

M=M+D
A=M
D=M 
@SP
A=M
M=D
@0
D=A
@ARG

M=M-D
@SP
M=M+1
//return

//frame = lcl
@LCL
D=M
@R13 // frame
M=D

// ret = *(frame-5)
@5
D=A
@R13
D=M-D
A=D
D=M
@R14 // ret
M=D

// *arg = pop()
@SP
M=M-1
A=M
D=M
@ARG
A=M
M=D

// sp = arg + 1
@ARG
D=M+1
@SP
M=D

//restore that
@R13
D=M-1
A=D
D=M
@THAT
M=D

//restore this
@2
D=A
@R13
D=M-D
A=D
D=M
@THIS
M=D

//restore arg
@3
D=A
@R13
D=M-D
A=D
D=M
@ARG
M=D


//restore lcl
@4
D=A
@R13
D=M-D
A=D
D=M
@LCL
M=D


@R14
A=M
0;JMP
//label IF_FALSE         // if n>=2, returns fib(n-2)+fib(n-1)

($IF_FALSE)
//push argument 0

@0
D=A
@ARG

M=M+D
A=M
D=M 
@SP
A=M
M=D
@0
D=A
@ARG

M=M-D
@SP
M=M+1
//push constant 2

@2
D=A
@SP

A=M
M=D
@SP
M=M+1

//sub

@SP
M=M-1
@SP
A=M
D=M
@SP
M=M-1
A=M
M=M-D

@SP
M=M+1
//call Main.fibonacci 1  // computes fib(n-2)

@Main.fibonacci.1
D=A
@SP
A=M
M=D
@SP
M=M+1

// push lcl
@LCL
D=M
@SP 
A=M
M=D
@SP
M=M+1

//push arg
@ARG
D=M
@SP 
A=M
M=D
@SP
M=M+1

// push this
@THIS
D=M
@SP 
A=M
M=D
@SP
M=M+1

// push that
@THAT
D=M
@SP 
A=M
M=D
@SP
M=M+1

// arg = SP-n-5
@1
D=A
@SP
D=M-D
@5
D=D-A
@ARG
M=D

// lcl = sp
@SP
D=M
@LCL
M=D

// goto f
@Main.fibonacci
0;JMP
(Main.fibonacci.1)//push argument 0

@0
D=A
@ARG

M=M+D
A=M
D=M 
@SP
A=M
M=D
@0
D=A
@ARG

M=M-D
@SP
M=M+1
//push constant 1

@1
D=A
@SP

A=M
M=D
@SP
M=M+1

//sub

@SP
M=M-1
@SP
A=M
D=M
@SP
M=M-1
A=M
M=M-D

@SP
M=M+1
//call Main.fibonacci 1  // computes fib(n-1)

@Main.fibonacci.2
D=A
@SP
A=M
M=D
@SP
M=M+1

// push lcl
@LCL
D=M
@SP 
A=M
M=D
@SP
M=M+1

//push arg
@ARG
D=M
@SP 
A=M
M=D
@SP
M=M+1

// push this
@THIS
D=M
@SP 
A=M
M=D
@SP
M=M+1

// push that
@THAT
D=M
@SP 
A=M
M=D
@SP
M=M+1

// arg = SP-n-5
@1
D=A
@SP
D=M-D
@5
D=D-A
@ARG
M=D

// lcl = sp
@SP
D=M
@LCL
M=D

// goto f
@Main.fibonacci
0;JMP
(Main.fibonacci.2)//add                    // returns fib(n-1) + fib(n-2)

@SP
M=M-1
@SP
A=M
D=M
@SP
M=M-1
A=M
M=M+D

@SP
M=M+1
//return

//frame = lcl
@LCL
D=M
@R13 // frame
M=D

// ret = *(frame-5)
@5
D=A
@R13
D=M-D
A=D
D=M
@R14 // ret
M=D

// *arg = pop()
@SP
M=M-1
A=M
D=M
@ARG
A=M
M=D

// sp = arg + 1
@ARG
D=M+1
@SP
M=D

//restore that
@R13
D=M-1
A=D
D=M
@THAT
M=D

//restore this
@2
D=A
@R13
D=M-D
A=D
D=M
@THIS
M=D

//restore arg
@3
D=A
@R13
D=M-D
A=D
D=M
@ARG
M=D


//restore lcl
@4
D=A
@R13
D=M-D
A=D
D=M
@LCL
M=D


@R14
A=M
0;JMP
(END)
@END
0;JMP
