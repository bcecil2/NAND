require_relative "VMParser.rb"

# Validates a directory based on whether is exists
# has .vm a files and is passing one or two arguments
def valid_dir
	ARGV.size <= 2 && Dir.exist?(ARGV[0])  && Dir.each_child(ARGV[0]).any?{ |file|  File.extname(file) == ".vm" }
end

# validates file based on its extension and arguments passed
def valid_file
	ARGV.size <= 2 && File.exist?(ARGV[0]) && File.extname(ARGV[0]) == ".vm"
end

# 1. Checks for -b flag which lets the parser know whether it should write bootstrap code
# 2. creates an array of all the VM files in the directory
# 3. gets the directory name to use for the final .asm file
# 4. goes through all the VM files with one parser translating to assembly
if  valid_dir 
	dir_name = ARGV[0]
	if ARGV.size == 2
		if ARGV[1] == "-b"
			bootstrap = true
		end
	end
	vm_files = Array.new
	Dir.each_child(dir_name) do |file|
		if File.extname(file) == ".vm"
			vm_files << file
		end
	end
	directories = dir_name.split("\\")
	file_to_write = File.open("#{dir_name}\\#{directories[-1]}.asm", "w") 
	vm_parser = Parser.new(file_to_write, bootstrap)
	vm_files.each do |file|
		vm_filename = file
		incoming_filename = File.basename(vm_filename, ".*")
		incoming_file = File.open("#{dir_name}\\#{incoming_filename}.vm", "r") 
		vm_parser.parse(incoming_file)
	end

# 1. Checks for -b flag which lets the parser know whether it should write bootstrap code
# 2. writes translated assembly to the file to write  			
elsif valid_file
	if ARGV.size == 2
		if ARGV[1] == "-b"
			bootstrap = true
		end
	end
	vm_filename = ARGV[0]
	incoming_filename = File.basename(vm_filename, ".*")
	vm_path = File.dirname("#{vm_filename}")
	asm_file = "#{vm_path}\\#{incoming_filename}.asm"
	incoming_file = File.open(vm_filename, "r")
	file_to_write = File.open(asm_file, "w")
	vm_parser = Parser.new(file_to_write, bootstrap)
	vm_parser.parse(incoming_file)
else
	puts "failed"
	puts ARGV[0], ARGV[1]
end
