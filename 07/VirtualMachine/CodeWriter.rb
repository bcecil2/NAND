require "erb"
Dir.each_child("./erbfiles") { |file| require_relative "#{file}" }


class CodeWriter

  attr_writer :asm_file
  attr_reader :index, :mem_segment_table
  def initialize(file_to_write)
    @asm_file = File.open(file_to_write, "w")
    @static_prefix =  File.basename(file_to_write).gsub(".asm", "")
    @label_count = 1
    @binary_operator_table = {"add" => "M=M+D\n",
                              "sub" => "M=M-D\n",
                              "and" => "M=M&D\n",
                              "or" => "M=M|D\n"}
                 
    @unary_operator_table = {"neg" => "M=-M\n","not" => "M=!M\n"}
    @mem_segment_table = {"constant" => "@SP\n",
                          "local" => "@LCL\n",
                          "this" => "@THIS\n",
                          "that" => "@THAT\n",
                          "argument" => "@ARG\n",
                          "temp" => "@5\n",
                          "pointer" => "@3\n",
                          "static" => "@16\n"}
    @push_file_table = {"constant" => "pushconstant.erb",
                       "temp" => "pushpointerandtemp.erb",
                       "pointer" => "pushpointerandtemp.erb",
                       "static" => "pushstatic.erb",
                       "local" => "pushargandlcl.erb",
                       "this" => "pushargandlcl.erb",
                       "that" => "pushargandlcl.erb",
                       "argument" => "pushargandlcl.erb"}

    @pop_file_table = {"temp" => "poptempandpointer.erb",
                       "pointer" => "poptempandpointer.erb",
                       "static" => "popstatic.erb",
                       "local" => "popargandlcl.erb",
                       "this" => "popargandlcl.erb",
                       "that" => "popargandlcl.erb",
                       "argument" => "popargandlcl.erb"}
    @jump_table = {"lt" => "D;JLT",
                   "gt" => "D;JGT",
                   "eq" => "D;JEQ"}
  end

  def write_arithmetic(command , line)
    @asm_file << "//#{line}\n"
    if @binary_operator_table.has_key? command
      @asm_file << ERB.new(File.read("binaryarithmetic.erb")).result(binding)
    elsif @unary_operator_table.has_key? command
      @asm_file << ERB.new(File.read("unaryarithmetic.erb")).result(binding)
    else
      jump_directive = @jump_table[command]
      @asm_file << ERB.new(File.read("equalityoperations.erb")).result(binding) 
      @label_count += 1
    end
  end

  def write_push_pop(command, segment, index, line)
    @asm_file << "//#{line}\n"
    if command == "C_PUSH"
      @asm_file << ERB.new(File.read(@push_file_table[segment])).result(binding)  
    elsif command == "C_POP"
      @asm_file << ERB.new(File.read(@pop_file_table[segment])).result(binding)
    end
  end

  # adds infinite loop used to terminate .asm files
  def add_end()
    @asm_file << "(END)\n@END\n0;JMP\n"            
  end

  # adjusts the stack pointer in preparation for a arithmetic operation that is binary
  def adjust_sp_binary()
    "@SP\nM=M-1\n@SP\nA=M\nD=M\n@SP\nM=M-1\nA=M\n"
  end

  # adjusts the stack pointer in preperation for a arithmetic operation that is unary
  def adjust_sp_unary()
    "@SP\nM=M-1\n@SP\nA=M\n"
  end

  # increments the stack pointer
  def increment_sp()
    "@SP\nM=M+1\n"
  end
end


