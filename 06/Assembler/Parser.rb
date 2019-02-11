
#load "main.rb"


class Parser
	attr_reader :file_size
	attr_reader :assembly_file
	attr_reader :currentcommand
	attr_reader :currentlinenumber
	attr_writer :currentcommand

	def initialize()
		name = get_filename
		@assembly_file = File.open("#{name}", "r")
		@linecount = IO.readlines(@assembly_file).size
		@currentlinenumber = 0
		@currentcommand = ""
	end

	def has_more_commands()
		@currentlinenumber + 1 < @linecount
	end

	def advance()
		if has_more_commands
			@currentcommand = @assembly_file.gets.chomp.gsub(/\s+/, '') # gets line, chomp removes newline characters, gsub hack shit to remove whitespace
			@currentlinenumber = $. - 1 # evil magic variable that tells you the number of last line read
		end
	end

	def command_type()
		type = ""
		unless @currentcommand.empty?
			if @currentcommand.match(/^[\/]{2}/) # matches // placed at beginning of line
				type = "COMMENT"
			elsif @currentcommand.match(/^[@]\d/) # matches @ placed at beginning of line followed by any digit
				type = "A"
			elsif @currentcommand.match(/([=]|[;])/) # mathches any line containg = or ; placed at beginning of line 
				type = "C"
			end
		end
	end

	def symbol()
		symbol_string =""
		if command_type() == "A"
			symbol_string = @currentcommand[1..@currentcommand.size] # slices anything past @
		end
	end

	def dest()
		dest_string = ""
		if command_type() == "C"
			if @currentcommand.match(/[=]/)
				dest_array = @currentcommand.split("=")
				dest_string = dest_array[0] # returns the substring of any matches to the left of =
			end
		end
		return dest_string
	end

	def comp()
		comp_string = ""
		if command_type() == "C"
			if @currentcommand.match(/[=]/)
				computation_array = @currentcommand.split("=") # splits string on either side of the equals sign
				comp_string = computation_array[1]
			elsif @currentcommand.match(/[;]/)
				computation_array = @currentcommand.split(";")
				comp_string = computation_array[0]
			end
		end
		return comp_string
	end

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




