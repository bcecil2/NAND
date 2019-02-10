
load "main.rb"


class Parser
	attr_reader :file_size
	attr_reader :assembly_file
	attr_reader :currentcommand

	def initialize()
		name = get_filename
		@assembly_file = File.open("#{name}", "r")
		@linecount = IO.readlines(@assembly_file).size
		@currentlinenumber = 0
		@currentcommand = ""
	end

	def has_more_commands()
		@currentlinenumber < @linecount
	end

	def advance()
		if has_more_commands
			@currentcommand = @assembly_file.gets.chomp.gsub(/\s+/, '')
			@currentlinenumber += 1
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
end

boi = Parser.new()

while boi.has_more_commands
	unless boi.currentcommand.empty?
		boi.advance
		puts " current command is #{boi.currentcommand} and is of type #{boi.command_type}"
	end
	boi.advance		
end

