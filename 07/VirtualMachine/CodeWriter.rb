class CodeWriter

  attr_writer :asm_file
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
  end

  def write_arithmetic(command , line)
    @asm_file << "//#{line}\n"
    if @binary_operator_table.has_key? command
      @asm_file << "#{adjust_sp_binary}" << @binary_operator_table[command] << "#{increment_sp}"
    elsif @unary_operator_table.has_key? command
      @asm_file << "#{adjust_sp_unary}" << @unary_operator_table[command] << "#{increment_sp}"
    else
      if command == "lt"
        jump_directive = "D;JLT"
      elsif command == "gt"
        jump_directive = "D;JGT"
      elsif command == "eq"
        jump_directive = "D;JEQ"
      end
      @asm_file << "#{adjust_sp_binary}D=M-D\n@TRUECASE#{@label_count}\n#{jump_directive}\n@NOTTRUECASE#{@label_count}\n0;JMP\n(TRUECASE#{@label_count})\n"\
      "@SP\nA=M\nM=-1\n@CHANGESP#{@label_count}\n0;JMP\n(NOTTRUECASE#{@label_count})\n@SP\nA=M\nM=0\n(CHANGESP#{@label_count})\n#{increment_sp}"     
      @label_count += 1
    end
  end

  def write_push_pop(command, segment, index, line)
    @asm_file << "//#{line}\n"
    if command == "C_PUSH"
      if segment == "constant"
        @asm_file << "@#{index}\nD=A\n" << @mem_segment_table[segment] << "A=M\nM=D\n#{increment_sp}"
      elsif segment == "temp" || segment == "pointer"
        @asm_file << push_temp(segment, index) << increment_sp  
      elsif segment == "static"
        @asm_file << push_static(index) << increment_sp
      else
        @asm_file  << write_ptr_offset(segment, index) << push_to_segment << undo_ptr_offset(segment, index) << increment_sp
      end   
    elsif command == "C_POP"
      if segment == "temp" || segment == "pointer"
        @asm_file << pop_temp(segment, index) 
      elsif segment == "static"
        @asm_file << pop_static(index)
      else  
        @asm_file << write_ptr_offset(segment, index) << pop_to_segment(segment) << undo_ptr_offset(segment, index)
      end
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

  # pops the topmost item off the stack accesses the corresponding memory segment pointer and stores the popped item in that address
  def pop_to_segment(segment)
    "@SP\nM=M-1\nA=M\nD=M\n#{@mem_segment_table[segment]}\nA=M\nM=D\n"
  end

  # helper fucntion used to push item referenced by segment onto the stack
  def push_to_segment()
   "A=M\n D=M\n @SP\n A=M\n M=D\n"
  end

    # calculates the pointers offset from its base and stores it in the pointers place
  def write_ptr_offset(segment, index)
    "@#{index}\nD=A\n#{@mem_segment_table[segment]}\nM=M+D\n"
  end

  # undoes the offset calculated so that the pointer points back to its base
  def undo_ptr_offset(segment, index)
    "@#{index}\nD=A\n#{@mem_segment_table[segment]}\nM=M-D\n"
  end

  # pops the topmost item off the stack and store it in temp by
  # 1 calculating the offset from the base of the temp segment (5) and storing it in R13
  # 2 putting the topmost item popped off the stack into the address pointed to by R13
  def pop_temp(segment, index)
    "@#{index}\nD=A\n#{@mem_segment_table[segment]}\nA=A+D\nD=A\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D\n"
  end

  # pushes whatever is stored in the temp onto the stack
  def push_temp(segment, index)
    "@#{index}\nD=A\n#{@mem_segment_table[segment]}\nA=A+D\nD=M\n@SP\nA=M\nM=D\n"
  end

  # pushes the value indexed from the static section to the stack
  def push_static(index)
    write_static_offset(index) << "A=A+D\nD=M\n@SP\nA=M\nM=D\n"
  end

  # pops the topmost item off the stack into the segment of static memory based on the index
  def pop_static(index)
    write_static_offset(index) << "D=A+D\n@R13\nM=D\n@SP\nM=M-1\nA=M\nD=M\n@R13\nA=M\nM=D\n"
  end

  # calculates the offset based on the variables number in ram and the base of the static segment (16)
  def write_static_offset(index)
    "@#{@static_prefix}.#{index}\nD=A\n@16\nD=D-A\n@#{index}\nD=A-D\n@#{@static_prefix}.#{index}\n"
  end
end