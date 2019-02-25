require_relative "VMParser.rb"

def valid_dir
	ARGV.size == 1 && Dir.exist?(ARGV[0])  && Dir.each_child(ARGV[0]).any?{ |file|  File.extname(file) == ".vm" }
end


def valid_file
	ARGV.size == 1 && File.exist?(ARGV[0]) && File.extname(ARGV[0]) == ".vm"
end

if  valid_dir 
	dir_name = ARGV[0]
	vm_files = Array.new
	Dir.each_child(dir_name) do |file|
		if File.extname(file) == ".vm"
			vm_files << file
		end
	end
	directories = dir_name.split("\\")
	file_to_write = File.open("#{dir_name}\\#{directories[-1]}.asm", "w") 
	vm_parser = Parser.new(file_to_write)
	vm_files.each do |file|
		vm_filename = file
		incoming_filename = File.basename(vm_filename, ".*")
		incoming_file = File.open("#{dir_name}\\#{incoming_filename}.vm", "r") 
		vm_parser.parse(incoming_file)
	end			
elsif valid_file
	vm_filename = ARGV[0]
	incoming_filename = File.basename(vm_filename, ".*")
	vm_path = File.dirname("#{vm_filename}")
	asm_file = "#{vm_path}\\#{incoming_filename}.asm"
	incoming_file = File.open(vm_filename, "r")
	file_to_write = File.open(asm_file, "w")
	vm_parser = Parser.new(incoming_file, file_to_write)
	vm_parser.parse
else
	puts "failed"
end
