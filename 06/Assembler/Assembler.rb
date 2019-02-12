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
		@variable_count = 0
	end

	def first_pass(incoming_line)
		@Parser.advance(incoming_line)
		if @Parser.command_type == "A" || @Parser.command_type == "C" # if we have an A or C command increment the ROM line counter
			@ROM_address += 1
		elsif @Parser.command_type == "L" # if we have a label get its name and create an entry in the symbol table with its corresponding address
			@symbol_table.add_entry(@Parser.currentcommand.gsub(/^[(]|[)]/, ""), @ROM_address.to_s(2).rjust(16, "0"))
		end
	end

	def second_pass(incoming_line)
		@Parser.currentcommand = ""
		@Parser.advance(incoming_line) # reads in incoming line
		@Parser.currentcommand
		if @Parser.command_type == "A" # if its an A command
			variable_name = @Parser.symbol # grab whats to the right of the @
			#puts variable_name 
			unless @Parser.currentcommand.match(/^@[^a-zA-Z]/) # if its a variable
				if @symbol_table.symbols.key?(variable_name) # if the variable already exists
					#puts "getting key for #{variable_name}"
					variable_name = @symbol_table.symbols[variable_name] # get the key
					#puts "key for #{variable_name}"
					@Parser.currentcommand = variable_name # translate it to binary

				else # new variable translate to binary ram address starting at 16
					@Parser.currentcommand = @symbol_table.add_entry(variable_name, (16 + @variable_count).to_s(2).rjust(16, "0"))
					@variable_count += 1
				end
			else # just a constant that can be converted
				@Parser.currentcommand = variable_name.to_i.to_s(2).rjust(16, "0")
			end
		elsif @Parser.command_type() == "C"
			    c_command = "111"
				@Parser.currentcommand = c_command << @CodeGenerator.comp(@Parser.comp()) << @CodeGenerator.dest(@Parser.dest()) << @CodeGenerator.jump(@Parser.jump())
		end
		return @Parser.currentcommand
	end
		 	 
end


