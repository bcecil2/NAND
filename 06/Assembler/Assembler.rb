load "CodeGenerator.rb"
load "Parser.rb"
load "SymbolTable.rb"


class Assembler

	attr_reader :Parser
	attr_reader :symbol_table

	def initialize(file)
		@CodeGenerator = CodeGenerator.new
		@Parser = Parser.new(file)
		@symbol_table = SymbolTable.new
		@ROM_address = 0
	end

	def first_pass(incoming_line)
		@Parser.advance(incoming_line)
		if @Parser.command_type == "A" || @Parser.command_type == "C"
			@ROM_address += 1
		elsif @Parser.command_type == "L"
			@symbol_table.add_entry(@Parser.currentcommand, @ROM_address)
		end
	end
		 	 

	def assemble_line(incoming_line, file_to_write)
		@Parser.advance(incoming_line)
		if @Parser.command_type == "A"
			a_command = @Parser.symbol().to_i.to_s(2).rjust(16, "0")
			file_to_write << a_command << "\n"
		elsif @Parser.command_type() == "C"
				c_command = "111"
				c_command << @CodeGenerator.comp(@Parser.comp()) << @CodeGenerator.dest(@Parser.dest()) << @CodeGenerator.jump(@Parser.jump()) 
				file_to_write << c_command << "\n" 
		end	
	end
end


