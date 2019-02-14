
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
	vm_files.each do |file|
		vm_filename = file
		incoming_filename = File.basename(vm_filename, ".*")
		asm_file = "#{dir_name}\\#{incoming_filename}.asm"
		incoming_file = File.open("#{dir_name}\\#{incoming_filename}.vm", "r") 
		file_to_write = File.open("#{asm_file}", "w") 
		incoming_file.each do |line|
			 file_to_write << line
		end
	end			
elsif valid_file
	vm_filename = ARGV[0]
	incoming_filename = File.basename(vm_filename, ".*")
	vm_path = File.dirname("#{vm_filename}")
	asm_file = "#{vm_path}\\#{incoming_filename}.asm"
else
	puts "failed"
end
