class CodeWriter

	attr_writer :asm_file
	def initialize(file_to_write)
		@asm_file = File.open(file_to_write, "w")
		@label_count = 1
		@binary_operator_table = {"add" => "M=M+D\n",
		 					 	  "sub" => "M=M-D\n",
		 				     	  "and" => "M=M&D\n",
		 				          "or" => "M=M|D\n"}
		 				     
		@unary_operator_table = {"neg" => "M=-M\n","not" => "M=!M\n"}
	end

	def write_arithmetic(command , line)
		@asm_file << "//#{line}\n"
		if command == "eq"
			@asm_file << "#{adjust_sp_binary}D=M-D\n@EQUAL#{@label_count}\nD;JEQ\n@NOTEQUAL#{@label_count}\n0;JMP\n(EQUAL#{@label_count})\n@SP\nA=M\nM=-1\n@CHANGESP#{@label_count}\n0;JMP\n(NOTEQUAL#{@label_count})\n@SP\nA=M\nM=0\n(CHANGESP#{@label_count})\n#{increment_sp}"			
			@label_count += 1
		elsif command == "lt"
			@asm_file << "#{adjust_sp_binary}D=M-D\n@LESSTHAN#{@label_count}\nD;JLT\n@GREATERTHAN#{@label_count}\n0;JMP\n(LESSTHAN#{@label_count})\n@SP\nA=M\nM=-1\n@CHANGESP#{@label_count}\n0;JMP\n(GREATERTHAN#{@label_count})\n@SP\nA=M\nM=0\n@CHANGESP#{@label_count}\n0;JMP\n(CHANGESP#{@label_count})\n#{increment_sp}"
			@label_count += 1
		elsif command == "gt"
			@asm_file << "#{adjust_sp_binary}D=M-D\n@LESS#{@label_count}\nD;JLT\n@GREATER#{@label_count}\nD;JGT\n@LESS#{@label_count}\nD;JEQ\n(LESS#{@label_count})\n@SP\nA=M\nM=0\n@CHANGESP#{@label_count}\n0;JMP\n(GREATER#{@label_count})\n@SP\nA=M\nM=-1\n@CHANGESP#{@label_count}\n0;JMP\n(CHANGESP#{@label_count})\n#{increment_sp}"
			@label_count += 1
		elsif @binary_operator_table.has_key? command
			@asm_file << "#{adjust_sp_binary}" << @binary_operator_table[command] << "#{increment_sp}"
		elsif @unary_operator_table.has_key? command
			@asm_file << "#{adjust_sp_unary}" << @unary_operator_table[command] << "#{increment_sp}"	
		end

	end

	def write_push_pop(command, segment, index, line)
		@asm_file << "//#{line}\n"
		if command == "C_PUSH"
			@asm_file << "@#{index}\nD=A\n@SP\nA=M\nM=D\n#{increment_sp}"
	    end
	end

	def add_end()
		@asm_file << "(END)\n@END\n0;JMP\n"
	end

	def adjust_sp_binary()
		"@SP\nM=M-1\n@SP\nA=M\nD=M\n@SP\nM=M-1\nA=M\n"
	end

	def adjust_sp_unary()
		"@SP\nM=M-1\n@SP\nA=M\n"
	end

	def increment_sp()
		"@SP\nM=M+1\n"
	end

end