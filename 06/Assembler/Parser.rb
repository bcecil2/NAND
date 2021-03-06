

class Parser
	attr_reader :currentcommand
	attr_writer :currentcommand

	def initialize()
		@currentcommand = ""
	end


	# gets the next line from the assembly file cleans it and increases line count
	def advance(command)
			@currentcommand = command.chomp.gsub(" ", '') # gets line, chomp removes newline characters, gsub to remove whitespace
			if @currentcommand.match(/[\/]{2}/) # checks for inline comment 
				currentcommand = @currentcommand.split("//") 
				@currentcommand = currentcommand[0]
			end
	end

	# returns type of current command as A, C, or L
	def command_type()
		type = ""
		unless @currentcommand.empty?
			if @currentcommand.match(/^[@][\da-zA-z]+/) # matches @ placed at beginning of line followed by any digit or characters
				type = "A"
			elsif @currentcommand.match(/([=]|[;])/) # mathches any line containg = or ; placed at beginning of line 
				type = "C"
			elsif @currentcommand.match(/^[(][a-zA-Z_.:$\d)]+/) # matches smybolic commands of form (EXPRESSION_.$:)
				type = "L"	
			end
		end
	end

	# returns the symbol of the current command following the @
	def symbol()
		symbol_string =""
		if command_type() == "A"
			symbol_string = @currentcommand[1..@currentcommand.size] # slices anything past @
		end
	end

	# returns the destination of the current C command
	def dest()
		dest_string = ""
		if command_type() == "C"
			if @currentcommand.match(/[=]/)
				dest_array = @currentcommand.split("=") # splits current command on the left of =
				dest_string = dest_array[0] 
			end
		end
		return dest_string
	end

	# returns the comp of the current C command
	def comp()
		comp_string = ""
		if command_type() == "C"
			computation_array = (@currentcommand.match(/[=]/)) ? @currentcommand.split("=") : @currentcommand.split(";")
			comp_string = (@currentcommand.match(/[=]/)) ? computation_array[1] : computation_array[0]
		end
		return comp_string
	end

	# returns the jump of the current C command
	def jump()
		jump_string = ""
		if command_type() == "C"
			if @currentcommand.match(/[;]/)
				jump_array = @currentcommand.split(";") # splits string on either side of the ;
				jump_string = jump_array[1]
			end
		end
		return jump_string
	end

end
