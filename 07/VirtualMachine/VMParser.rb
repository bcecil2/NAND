require_relative "CodeWriter.rb"


class Parser
  attr_reader :current_line
  
  def initialize(in_file, out_file)
    @current_line = ""
    @vm_file = in_file.readlines
    @code_writer = CodeWriter.new(out_file) 
  end

  def clean_comments()
    @vm_file.delete_if{|index| index.match(/[\/]{2}/) }
  end

  def clean(incoming_line)
    @current_line = incoming_line.split(" ")
  end

  def command_type(incoming_line)
    if incoming_line.include?("push")
      command_type = "C_PUSH"
    elsif incoming_line.include?("pop")
      command_type = "C_POP"
    elsif incoming_line.match(/\badd\b|\bsub\b|\bneg\b/)
      command_type = "C_ARITHMETIC"
    elsif incoming_line.match(/\beq\b|\blt\b|\bgt\b/)
      command_type = "C_ARITHMETIC"
    elsif incoming_line.match(/\bor\b|\bnot\b|\band\b/)
      command_type = "C_ARITHMETIC"   
    end

  end

  def arg1(incoming_line)
    if command_type(incoming_line) == "C_PUSH"
      arg1 = @current_line[1]
    elsif command_type(incoming_line) == "C_POP"
      arg1 = @current_line[1]
    elsif command_type(incoming_line) == "C_ARITHMETIC" 
      arg1 = @current_line[0]
    end
  end

  def arg2(incoming_line)
    if command_type(incoming_line) == "C_PUSH"
      arg2 = @current_line[2]
    elsif command_type(incoming_line) == "C_POP"
      arg2 = @current_line[2]
    end
    arg2.to_i
  end



  def parse()
    clean_comments
    @vm_file.each do |line|
      unless line.empty?
        type = command_type(line)
        if type == "C_PUSH" || type == "C_POP"
          clean(line)
          @code_writer.write_push_pop(type, arg1(line), arg2(line), line)
        elsif command_type(line) == "C_ARITHMETIC"
          clean(line)
          @code_writer.write_arithmetic(arg1(line), line)
        end
      end
    end
    @code_writer.add_end
  end
end
