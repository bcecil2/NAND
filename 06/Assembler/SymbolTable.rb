class SymbolTable

	attr_reader :symbols
	def initialize()
		@symbols = {"SP" => "0".to_i.to_s(2).rjust(16, "0"),
		            "LCL" => "1".to_i.to_s(2).rjust(16, "0"),
		            "ARG" => "2".to_i.to_s(2).rjust(16, "0"),
		            "THIS" => "3".to_i.to_s(2).rjust(16, "0"),
		            "THAT" => "4".to_i.to_s(2).rjust(16, "0"),
		            "SCREEN" => "16384".to_i.to_s(2).rjust(16, "0"),
		            "KBD" => "24576".to_i.to_s(2).rjust(16, "0")}
		(0..15).each do |counter|
			@symbols["R#{counter}"] = "#{counter}".to_i.to_s(2).rjust(16, "0")
		end
	end
end




