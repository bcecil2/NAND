class Tokenizer
	def initialize() 
		@current_token = ""

		@token_table = { "class" => "keyword",
						 "constructor" => "keyword",
						 "function" => "keyword",
						 "method" => "keyword",
						 "field" => "keyword",
						 "static" => "keyword",
						 "var" => "keyword",
						 "int" => "keyword",
						 "char" => "keyword",
						 "boolean" => "keyword",
						 "void" => "keyword",
						 "true" => "keyword",
						 "false" => "keyword",
						 "null" => "keyword",
						 "this" => "keyword",
						 "let" => "keyword",
						 "do" => "keyword",
						 "if" => "keyword",
						 "else" => "keyword",
						 "while" => "keyword",
						 "return" => "keyword",}
		@symbol_table = { "{" => "symbol", 
						 "}" => "symbol",
						 "(" => "symbol",
						 ")" => "symbol",
						 "[" => "symbol",
						 "]" => "symbol",
						 "." => "symbol",
						 "," => "symbol",
						 ";" => "symbol",
						 "+" => "symbol",
						 "-" => "symbol",
						 "*" => "symbol",
						 "/" => "symbol",
						 "&" => "symbol",
						 "|" => "symbol",
						 "<" => "symbol",
						 ">" => "symbol",
						 "=" => "symbol",
						 "~" => "symbol"}
		@special_tokens  = {"<" => "&lt;",
							">" => "&gt;",
							"&" => "&amp;"}
	end


	def write_identifier(curr_token)
		if curr_token.match(/[\d]/)
			message =  "<integerConstant> #{curr_token} </integerConstant>"
		else
			message =  "<identifier> #{curr_token} </identifier>"
		end
		return message
	end

	def write_string(curr_token)
		puts  "<stringConstant> #{curr_token} </stringConstant>"
		@outfile << "<stringConstant> #{curr_token} </stringConstant>"
	end

	def is_symbol(curr_token)
		@symbol_table.has_key?(curr_token)
	end

	def fucked(curr_token)
		message = "nil"
		if curr_token.count("\"") == 2
			message =  "<stringConstant> #{curr_token.gsub("\"", "")} </stringConstant>"
		end
		if @token_table.has_key?(curr_token) || @symbol_table.has_key?(curr_token)
			if @token_table.has_key?(curr_token)
				 message =  "<#{@token_table[curr_token]}> #{curr_token} </#{@token_table[curr_token]}>"
			elsif @symbol_table.has_key?(curr_token)
				if curr_token == "<" || curr_token == "&" || curr_token == ">" 
				 	curr_token = @special_tokens[curr_token]
				 	message =  "<symbol> #{curr_token} </symbol>"
				else
				 	message =  "<#{@symbol_table[curr_token]}> #{curr_token} </#{@symbol_table[curr_token]}>"
				end
			end
		end
		return message
	end
end