module Google
	module Books
		class Pdf
			attr_reader :is_available

			def initialize(pdf)
				if pdf
					@is_available = pdf["isAvailable"]
				end
			end
		end
	end
end
