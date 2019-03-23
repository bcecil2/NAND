require_relative "JackTokenizer.rb"

class CompilationEngine

	def initialize(infile)
		@tokenizer = Tokenizer.new()
		@in_file = nil
		@outfile = File.open(infile, "w")
		@current_token = ""
	end

	def clean_comments(file)
    	@in_file = file.readlines
    	@in_file.delete_if{|index| index.match(/^[\/**]|[**]/) }
    	@in_file.each do |line|
    		if line.match("//")
    			line[line.rindex("//")..line.length-1] = ""
    		end
    	end
  	end

	def parse(file)
		@in_file = file
		clean_comments(file)
		@outfile << "<tokens>"
		@in_file.each do |line|
			@current_token = "" 
			line.each_char do |char|
				if char == " " && @current_token.include?("\"")
					@current_token += char
				end
				if char != " "
					@current_token += char
				end
				if @tokenizer.fucked(@current_token) != "nil"
					@outfile << @tokenizer.fucked(@current_token)
					@current_token = ""
				elsif @current_token.length != 0
					if char == " " && !@current_token.include?("\"")
						@outfile << @tokenizer.write_identifier(@current_token)
						@current_token = ""
					elsif @tokenizer.is_symbol(char)
						@outfile << @tokenizer.write_identifier(@current_token[0..-2])
						@outfile << @tokenizer.fucked(char)
						@current_token = ""
					end
				end
			end
		end
		@outfile << "</tokens>"
	end
end