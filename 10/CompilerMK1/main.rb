require_relative "CompilationEngine.rb"

# Validates a directory based on whether is exists
# has .jack a files and is passing one or two arguments
def valid_dir
	ARGV.size <= 2 && Dir.exist?(ARGV[0])  && Dir.each_child(ARGV[0]).any?{ |file|  File.extname(file) == ".jack" }
end

# validates file based on its extension and arguments passed
def valid_file
	ARGV.size <= 2 && File.exist?(ARGV[0]) && File.extname(ARGV[0]) == ".jack"
end

# 1. Checks for -b flag which lets the parser know whether it should write bootstrap code
# 2. creates an array of all the jack files in the directory
# 3. gets the directory name to use for the final .asm file
# 4. goes through all the jack files with one parser translating to assembly
if  valid_dir 
	dir_name = ARGV[0]
	jack_files = Array.new
	Dir.each_child(dir_name) do |file|
		if File.extname(file) == ".jack"
			jack_files << file
		end
	end
	directories = dir_name.split("\\")
	file_to_write = File.open("#{dir_name}\\#{directories[-1]}.xml", "w") 
	jack_parser = Tokenizer.new(file_to_write)
	jack_files.each do |file|
		jack_filename = file
		incoming_filename = File.basename(jack_filename, ".*")
		incoming_file = File.open("#{dir_name}\\#{incoming_filename}.jack", "r") 
		jack_parser.parse(incoming_file)
	end

# 1. Checks for -b flag which lets the parser know whether it should write bootstrap code
# 2. writes translated assembly to the file to write  			
elsif valid_file
	jack_filename = ARGV[0]
	incoming_filename = File.basename(jack_filename, ".*")
	jack_path = File.dirname("#{jack_filename}")
	xml_file = "#{jack_path}\\#{incoming_filename}.xml"
	incoming_file = File.open(jack_filename, "r")
	file_to_write = File.open(xml_file, "r")
	jack_parser = CompilationEngine.new(file_to_write)
	jack_parser.parse(incoming_file)
else
	puts "failed"
	puts ARGV[0], ARGV[1]
end