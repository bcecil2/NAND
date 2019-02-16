class CodeWriter

	attr_writer :asm_file
	def initialize(file_to_write)
		@asm_file = File.open(file_to_write, "w")
		@label_count = 1
	end

	def write_arithmetic(command , line)
		@asm_file << "//#{line}\n"
		if command == "add"
			@asm_file << "@SP\nM=M-1\n@SP\nA=M\nD=M\n@SP\nM=M-1\nA=M\nM=M+D\n@SP\nM=M+1\n"
		elsif command == "sub"
			@asm_file << "@SP\nM=M-1\n@SP\nA=M\nD=M\n@SP\nM=M-1\nA=M\nM=M-D\n@SP\nM=M+1\n"
		elsif command == "neg"
			@asm_file << "@SP\nM=M-1\n@SP\nA=M\nM=-M\n@SP\nM=M+1\n"
		elsif command == "eq"
			@asm_file << "@SP\nM=M-1\n@SP\nA=M\nD=M\n@SP\nM=M-1\nA=M\nD=M-D\n@EQUAL#{@label_count}\nD;JEQ\n@NOTEQUAL#{@label_count}\n0;JMP\n(EQUAL#{@label_count})\n@SP\nA=M\nM=-1\n@CHANGESP#{@label_count}\n0;JMP\n(NOTEQUAL#{@label_count})\n@SP\nA=M\nM=0\n(CHANGESP#{@label_count})\n@SP\nM=M+1\n"			
			@label_count += 1
		elsif command == "lt"
			@asm_file << "@SP\nM=M-1\n@SP\nA=M\nD=M\n@SP\nM=M-1\nA=M\nD=M-D\n@LESSTHAN#{@label_count}\nD;JLT\n@GREATERTHAN#{@label_count}\n0;JMP\n(LESSTHAN#{@label_count})\n@SP\nA=M\nM=-1\n@CHANGESP#{@label_count}\n0;JMP\n(GREATERTHAN#{@label_count})\n@SP\nA=M\nM=0\n@CHANGESP#{@label_count}\n0;JMP\n(CHANGESP#{@label_count})\n@SP\nM=M+1\n"
			@label_count += 1
		elsif command == "gt"
			@asm_file << "@SP\nM=M-1\n@SP\nA=M\nD=M\n@SP\nM=M-1\nA=M\nD=M-D\n@LESS#{@label_count}\nD;JLT\n@GREATER#{@label_count}\nD;JGT\n@LESS#{@label_count}\nD;JEQ\n(LESS#{@label_count})\n@SP\nA=M\nM=0\n@CHANGESP#{@label_count}\n0;JMP\n(GREATER#{@label_count})\n@SP\nA=M\nM=-1\n@CHANGESP#{@label_count}\n0;JMP\n(CHANGESP#{@label_count})\n@SP\nM=M+1\n"
			@label_count += 1
		elsif command == "and"
			@asm_file << "@SP\nM=M-1\n@SP\nA=M\nD=M\n@SP\nM=M-1\nA=M\nM=M&D\n@SP\nM=M+1\n"
		elsif command == "or"
			@asm_file << "@SP\nM=M-1\n@SP\nA=M\nD=M\n@SP\nM=M-1\nA=M\nM=M|D\n@SP\nM=M+1\n"
		elsif command == "not"
			@asm_file << "@SP\nM=M-1\n@SP\nA=M\nM=!M\n@SP\nM=M+1\n"	
		end

	end

	def write_push_pop(command, segment, index, line)
		@asm_file << "//#{line}\n"
		if command == "C_PUSH"
			@asm_file << "@#{index}\nD=A\n@SP\nA=M\nM=D\n@SP\nM=M+1\n"
	    end
	end

	def add_end()
		@asm_file << "(END)\n@END\n0;JMP\n"
	end


end