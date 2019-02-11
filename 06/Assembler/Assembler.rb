load "CodeGenerator.rb"
load "Parser.rb"


class Assembler

	def initialize(file)
		@CodeGenerator = CodeGenerator.new
		@Parser = Parser.new(file)
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


