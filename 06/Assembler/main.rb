load "CodeGenerator.rb"
load "Parser.rb"

def valid_args
	ARGV.size == 1 && File.extname(ARGV[0]) == ".asm" && File.exist?(ARGV[0])
end

def get_filename
	file_name = ARGV[0]
end

if  valid_args
	asm_filename = ARGV[0]
	incoming_filename = File.basename(asm_filename, ".*")
	asm_path = File.dirname("#{asm_filename}")
	hack_file = "#{asm_path}\\#{incoming_filename}.hack"
	assembly_file = File.open("#{asm_filename}", "r")
	file_to_fill = File.open("#{hack_file}", "w")
	code_parser = Parser.new
	code_generator = CodeGenerator.new
	while code_parser.has_more_commands
		code_parser.advance
		unless code_parser.currentcommand.empty?
			if code_parser.command_type() == "A"
				x = code_parser.symbol().to_i.to_s(2).rjust(16, "0")
				file_to_fill << x << "\n"
			elsif code_parser.command_type() == "C"
				y = "111"
				y << code_generator.comp(code_parser.comp()) << code_generator.dest(code_parser.dest()) << code_generator.jump(code_parser.jump()) << "\n"
				file_to_fill << y   
			end	
		end
	end
else
	puts "call to main with invalid arguments"
end







