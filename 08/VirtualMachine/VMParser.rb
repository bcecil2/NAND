require_relative "CodeWriter.rb"


class Parser
  attr_reader :current_line
  
  def initialize(out_file)
    @current_line = ""
    @code_writer = CodeWriter.new(out_file)
    @in_file = nil
    @code_writer.write_bootstrap()
    @command_type_table ={"push" => "C_PUSH",
                        "pop" => "C_POP",
                        "add" => "C_ARITHMETIC",
                        "sub" => "C_ARITHMETIC",
                        "neg" => "C_ARITHMETIC",
                        "eq" => "C_ARITHMETIC",
                        "lt" => "C_ARITHMETIC",
                        "gt" => "C_ARITHMETIC",
                        "or" => "C_ARITHMETIC",
                        "not" => "C_ARITHMETIC",
                        "and" => "C_ARITHMETIC",
                        "if-goto" => "C_IF",
                        "label" => "C_LABEL",
                        "goto" => "C_GOTO",
                        "function" => "C_FUNCTION",
                        "return" => "C_RETURN",
                        "call" => "C_CALL"}

    @function_call_table = {"C_PUSH" => "write_push_pop",
                            "C_POP" => "write_push_pop",
                            "C_ARITHMETIC" => "write_arithmetic",
                            "C_LABEL" => "write_label",
                            "C_IF" => "write_if",
                            "C_GOTO" => "write_goto",
                            "C_RETURN" => "write_return",
                            "C_CALL" => "write_call",
                            "C_FUNCTION" => "write_function"} 
                            
    @arg1_table = {"C_PUSH" => 1,
                   "C_POP" => 1,
                   "C_IF" => 1,
                   "C_LABEL" => 1,
                   "C_GOTO" => 1,
                   "C_FUNCTION" => 1,
                   "C_CALL" => 1,
                   "C_ARITHMETIC" => 0,
                   "C_RETURN" => 0}
  end

  def clean_comments(file)
    @in_file = file.readlines
    @in_file.delete_if{|index| index.match(/^[\/]{2}/) }
  end

  def clean(incoming_line)
    @current_line = incoming_line.split(" ")
  end

  def command_type(incoming_line)
    @command_type_table[incoming_line]
  end

  def arg1(type)
    arg1 = @current_line[@arg1_table[type]]
  end

  def arg2(type)
    arg2 = @current_line[2]
    arg2.to_i
  end



  def parse(file)
    clean_comments(file)
    @code_writer.static_prefix = File.basename(file).gsub(".vm", "")
    @in_file.each do |line|
      if !line.chomp.strip.empty?
        clean(line)
        type = command_type(@current_line[0])
        #@code_writer.method(@function_call_table[type]).call()
        if type == "C_PUSH" || type == "C_POP"
          @code_writer.write_push_pop(type, arg1(type), arg2(type), line)
        elsif type == "C_ARITHMETIC"
          @code_writer.write_arithmetic(arg1(type), line)
        elsif type == "C_LABEL"
          @code_writer.write_label(arg1(type), line)
        elsif type == "C_IF"
          @code_writer.write_if(arg1(type), line)
        elsif type == "C_GOTO"
          @code_writer.write_goto(arg1(type), line)
        elsif type == "C_FUNCTION"
          @code_writer.write_function(arg1(type), arg2(type), line)
        elsif type == "C_RETURN"
          @code_writer.write_return(line)
        elsif type == "C_CALL"
          @code_writer.write_call(arg1(type), arg2(type), line)
        end
      end
    end
    @code_writer.add_end
  end
end
