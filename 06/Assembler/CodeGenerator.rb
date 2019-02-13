class CodeGenerator

	def initialize()
		@comp_table_a0 = {"0" => "101010",
						  "1" => "111111",
						  "-1" => "111010",
						  "D" => "001100",
						  "A" => "110000",
						 "!D" => "110011",
						 "!A" => "001111",
						 "-D" => "001101",
					     "-A" => "110011",
						 "D+1" => "011111",
						 "A+1" => "110111",
						 "D-1" => "001110",
						 "A-1" => "110010",
						 "D+A" => "000010",
						 "D-A" => "010011",
						 "A-D" => "000111",
						 "D&A" => "000000",
						 "D|A" => "010101"}
		
		@comp_table_a1 = {"M" => "110000",
						  "!M" => "110001",
						  "-M" => "110011",
						  "M+1" => "110111",
						  "M-1" => "110010",
						  "D+M" => "000010",
						  "D-M" => "010011",
						  "M-D" => "000111",
						  "D&M" => "000000",
						  "D|M" => "010101"}
		
		@dest_table = {"M" => "001",
		               "D" => "010",
		               "MD" => "011",
		               "A" => "100",
		               "AM" => "101",
		               "AD" => "110",
		               "AMD" => "111"}
		
		@jump_table = {"JGT" => "001",
		               "JEQ" => "010",
		               "JGE" => "011",
		               "JLT" => "100",
		               "JNE" => "101",
		               "JLE" => "110",
		               "JMP" => "111"}
	end

	# returns destination bits of C instruction
	def dest(command)
		dest_bits = "000"
		unless command.empty?
			dest_bits = @dest_table[command]
		end	
		return dest_bits
	end
    
    # returns computation bits of C instruction
	def comp(command)
		unless command.empty?
			comp_bits = (command.include? "M") ? "1" : "0" # determines a prefix for c command
			if command.include? "M"
				comp_bits << @comp_table_a1[command]
				comp_bits = comp_bits
			else
				comp_bits << @comp_table_a0[command]
				comp_bits = comp_bits
			end
			return comp_bits
		end
	end

	#returns jump bits of C instruction
	def jump(command)
		jump_bits = "000"
		unless command.empty?
			jump_bits = @jump_table[command]
		end	
		return jump_bits	
	end

end

