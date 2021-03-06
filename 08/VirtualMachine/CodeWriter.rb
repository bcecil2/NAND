require "erb"

class CodeWriter

  attr_writer :asm_file
  attr_reader :index, :mem_segment_table
  attr_writer :static_prefix
  def initialize(file_to_write)
    @asm_file = File.open(file_to_write, "w")
    @static_prefix =  File.basename(file_to_write).gsub(".vm", "")
    @label_count = 1
    @current_function = Array.new(1, @static_prefix)
    @call_count = 0
    @static_table = Hash.new()
    @static_variables = Hash.new()
    @static_base = 16
    @static_count = 0

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
    if segment == "static"
      if !@static_table.has_key? ("#{@static_prefix}")
          add_entry_to_static_table
      elsif !@static_variables.has_key? ("#{@static_prefix}.#{index}")
          change_static_base_pointer
      end
    end
    if command == "C_PUSH"
      @asm_file << ERB.new(File.read(@push_file_table[segment])).result(binding)  
    elsif command == "C_POP"
      @asm_file << ERB.new(File.read(@pop_file_table[segment])).result(binding)
    end
  end

  def add_entry_to_static_table()
    @static_base += @static_count
    @static_table["#{@static_prefix}"] = @static_base
  end

  def change_static_base_pointer()
    @static_variables["#{@static_prefix}.#{index}"] = @static_base
    @static_count += 1
  end
  def write_if(label, line)
    @asm_file << "//#{line}\n"
    @asm_file << ERB.new(File.read("if-goto.erb")).result(binding)
  end

  def write_label(label, line)
    @label_count += 1
    @asm_file << "//#{line}\n"
    @asm_file << ERB.new(File.read("label.erb")).result(binding)
  end

  def write_goto(label, line)
    @asm_file << "//#{line}\n"
    @asm_file << ERB.new(File.read("goto.erb")).result(binding)
  end

  

  def write_function(function_name, num_locals, line)
    @current_function << function_name
    @asm_file << "//#{line}\n"
    @asm_file << "(#{function_name})\n" 
    (1..num_locals).each do |var|
      @asm_file << ERB.new(File.read("function.erb")).result(binding)
    end
  end

  def write_call(function_name, num_args, line)
    @call_count += 1
    @asm_file << "//#{line}\n"
    @asm_file << ERB.new(File.read("callfunc.erb")).result(binding)
  end

  def write_return(line)
    @asm_file << "//#{line}\n"
    @asm_file << ERB.new(File.read("return.erb")).result(binding)
  end

  def write_bootstrap()
    @asm_file << ERB.new(File.read("bootstrap.erb")).result(binding)
  end
  
  def add_end()
    @asm_file << "(END)\n@END\n0;JMP\n"
  end
end


