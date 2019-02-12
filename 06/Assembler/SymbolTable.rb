class SymbolTable

	attr_reader :symbols
	def initialize()
		@symbols = {"SP" => to_16bit_binary("0"),
		            "LCL" => to_16bit_binary("1"),
		            "ARG" => to_16bit_binary("2"),
		            "THIS" => to_16bit_binary("3"),
		            "THAT" => to_16bit_binary("4"),
		            "SCREEN" => to_16bit_binary("16384"),
		            "KBD" => to_16bit_binary("24576")
		           }
		(0..15).each do |counter|
			@symbols["R#{counter}"] = to_16bit_binary("#{counter}")
		end
	end

	def add_entry(symbol, address)
		@symbols[symbol] = address
	end

	def contains(string)
		@symbols.has_key?(string)
	end

	def get_address(string)
		@symbols[string]
	end

	def to_16bit_binary(string)
		string.to_i.to_s(2).rjust(16, "0")
	end
end




