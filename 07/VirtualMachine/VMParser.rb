class Parser
	attr_reader :current_line
  
	def initialize(in_file, out_file)
		@current_line = ""
		@vm_file = in_file.readlines
		@asm_file = out_file 
	end

# change this so we dont have to deal with spaces again
	def clean_line(incoming_line)
		@current_line = incoming_line.chomp.gsub(" ", '')
		if @current_line.match(/[\/]{2}/) # checks for inline comment 
				@current_line = @current_line.split("//") 
				@current_line = @current_line[0]
		end
	end

	def command_type()
		if @current_line.include?("push")
		  command_type = "C_PUSH"
		elsif @current_line.include?("pop")
			command_type = "C_POP"
		elsif @current_line.match(/\badd\b|\bsub\b|\bneg\b/)
		  command_type = "C_ARITHMETIC"
		elsif @current_line.match(/\beq\b|\blt\b|\bgt\b/)
			command_type = "C_EQUAL"
		elsif @current_line.match(/\bor\b|\bnot\b|\band\b/)
			command_type = "C_BOOL"
		end
	end

	def arg1()
		if command_type == "C_PUSH"
			arg1 = @current_line.split("push")[1].split(/[0-9]/)
		elsif command_type == "C_POP"
			arg1 = @current_line.split("pop")[1].split(/[0-9]/)
		elsif command_type == "C_ARITHMETIC"
			arg1 = @current_line
		end
	end

	def arg2()
		if command_type == "C_PUSH"
			arg2 = @current_line.gsub(/[a-z]/, "")
		elsif command_type == "C_POP"
			arg2 = @current_line.gsub(/[a-z]/, "")
		end
		arg2.to_i
	end



	def parse()
		@vm_file.each do |line|
			clean_line(line)
			unless @current_line.empty?
				
			end
		end
	end


end
