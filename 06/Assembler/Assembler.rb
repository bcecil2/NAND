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

	def first_pass(incoming_line)
		@Parser.advance(incoming_line)
		if @Parser.command_type == "A" || @Parser.command_type == "C" 
			@ROM_address += 1
		elsif @Parser.command_type == "L" 
			@symbol_table.add_entry(@Parser.currentcommand.gsub(/^[(]|[)]/, ""), to_16bit_binary(@ROM_address))
		end
	end

	def empty_line(incoming_line)
		incoming_line.gsub(" ", "").empty?
	end
	def second_pass(incoming_line)
		@Parser.currentcommand = ""
		@Parser.advance(incoming_line)
		if @Parser.command_type == "A" 
			variable_name = @Parser.symbol 
			unless @Parser.currentcommand.match(/^@[^a-zA-Z]/) 
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
	
	def handle_variable(variable_name)
		if @symbol_table.symbols.key?(variable_name) 
			@Parser.currentcommand = @symbol_table.symbols[variable_name] 
		else 
			@Parser.currentcommand = @symbol_table.add_entry(variable_name, to_16bit_binary((@VARIABLE_BASE_ADDRESS + @variable_count)))
			@variable_count += 1
		end
	end	 
end


