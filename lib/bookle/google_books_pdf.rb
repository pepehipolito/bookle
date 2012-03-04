module Google
	module Books
		class Pdf
			attr_reader :is_available

			def initialize(pdf)
				if pdf
					@is_available = pdf["isAvailable"]
				end
			end

			def to_hash
				{"is_pdf_available" => self.is_available}
			end

		end
	end
end
