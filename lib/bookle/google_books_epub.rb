module Google
	module Books
		class Epub
			attr_reader :is_available

			def initialize(epub)
				if epub
					@is_available = epub["isAvailable"]
				end
			end

		end
	end
end
