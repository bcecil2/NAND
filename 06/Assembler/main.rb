

def valid_args
	ARGV.size == 1 && File.extname(ARGV[0]) == ".asm" && File.exist?(ARGV[0])
end




if  valid_args
	asm_filename = ARGV[0]
	incoming_filename = File.basename(asm_filename, ".*")
	asm_path = File.dirname("#{asm_filename}")
	hack_file = "#{asm_path}\\#{incoming_filename}.hack"
	file_to_parse = File.open("#{asm_filename}", "r")
	file_to_fill = File.open("#{hack_file}", "w") 
	file_to_parse.each do |line|
		file_to_fill << line
	end

	
	file_to_fill.open("#{hack_file}", "r")
	file_to_fill.each do |line|
		puts line
	end

end


