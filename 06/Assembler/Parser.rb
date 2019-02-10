
load "main.rb"


class Parser
	attr_reader :file_size
	attr_reader :assembly_file
	attr_reader :currentcommand
	attr_reader :currentlinenumber

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

	def command_type(command)
		type = ""
		unless command.empty?
			if command.match(/^[\/]{2}/) # matches // placed at beginning of line
				type = "COMMENT"
			elsif command.match(/^[@]\d/) # matches @ placed at beginning of line followed by any digit
				type = "A"
			elsif command.match(/([=]|[;])/) # mathches any line containg = or ; placed at beginning of line 
				type = "C"
			end
		end
	end

	def symbol(command)
		symbol_string =""
		if command_type(command) == "A"
			symbol_string = command[1..command.size] # slices anything past @
		end
	end

	def dest(command)
		dest_string = ""
		if command_type(command) == "C"
			if command.match(/[=]/)
				dest_string = command[/^[AMD]/] # returns the substring of any matches to the left of =
			end
		end
	end

	def comp(command)
		comp_string = ""
		if command_type(command) == "C"
			if command.match(/[=]/)
				computation_array = command.split("=") # splits string on either side of the equals sign
				comp_string = computation_array[1]
			end
		end
	end

	def jump(command)
		jump_string = ""
		if command_type(command) == "C"
			if command.match(/[;]/)
				computation_array = command.split(";") # splits string on either side of the ;
				comp_string = computation_array[1]
			end
		end
	end

end

boi = Parser.new()
#while boi.has_more_commands
#		boi.advance
#		unless boi.currentcommand.empty?
#			puts " current command is #{boi.currentcommand} and is of type #{boi.command_type(boi.currentcommand)}"	
#			if boi.command_type(boi.currentcommand) == "A"
#				 #puts boi.symbol(boi.currentcommand)	
#			elsif boi.command_type(boi.currentcommand) == "C"
#				 puts boi.comp(boi.currentcommand)
#			end
#				
#		end
#end
while boi.has_more_commands
	boi.advance
	puts "current line #{boi.currentlinenumber} current command #{boi.currentcommand} "	
end
