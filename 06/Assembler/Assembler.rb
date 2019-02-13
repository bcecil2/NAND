load "CodeGenerator.rb"
load "Parser.rb"
load "SymbolTable.rb"


class Assembler

	attr_reader :Parser
	attr_reader :symbol_table

	def initialize()
		@CodeGenerator = CodeGenerator.new
		@Parser = Parser.new
		@symbol_table = SymbolTable.new
		@ROM_address = 0
		@variable_count = 0
		@VARIABLE_BASE_ADDRESS = 16
	end

	# first past marches through incoming file looking for labels and adding them to the symbol table with their associated pointer in ROM
	def first_pass(incoming_line)
		@Parser.advance(incoming_line)
		if @Parser.command_type == "A" || @Parser.command_type == "C" 
			@ROM_address += 1
		elsif @Parser.command_type == "L" 
			@symbol_table.add_entry(@Parser.currentcommand.gsub(/^[(]|[)]/, ""), to_16bit_binary(@ROM_address))
		end
	end

	# second pass marches through incoming file doing two main things
	# 1 if it comes across a variable it checks to see if its in the table if it is it replaces it with its binary value
	# 2 if it comes across a variable that is not in the table it adds it its offset from VARIABLE_BASE_ADDRESS as the value
	# other wise if it comes across a constant or C command it converts them to their binary
	def second_pass(incoming_line)
		@Parser.advance(incoming_line)
		if @Parser.command_type == "A" 
			variable_name = @Parser.symbol 
			unless @Parser.currentcommand.match(/^@[^a-zA-Z]/) # matches only with @ followed by only digits
				handle_variable(variable_name)
			else 
				@Parser.currentcommand = variable_name.to_i.to_s(2).rjust(16, "0")  
			end
			elsif @Parser.command_type() == "C"
				c_command = "111"
				@Parser.currentcommand = c_command << @CodeGenerator.comp(@Parser.comp()) << @CodeGenerator.dest(@Parser.dest()) << @CodeGenerator.jump(@Parser.jump()) 
		end 
		return @Parser.currentcommand
	end

	def to_16bit_binary(number)
		number.to_s(2).rjust(16, "0")
	end
	
	# handles the look up of labels and variables into the symbol table
	def handle_variable(variable_name)
		if @symbol_table.symbols.key?(variable_name) 
			@Parser.currentcommand = @symbol_table.symbols[variable_name] 
		else 
			@Parser.currentcommand = @symbol_table.add_entry(variable_name, to_16bit_binary((@VARIABLE_BASE_ADDRESS + @variable_count)))
			@variable_count += 1
		end
	end	 
end


