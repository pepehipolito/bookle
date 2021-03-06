module Google
	module Books
		class Epub
			attr_reader :is_available

			def initialize(epub)
				epub 					= {} unless epub
				@is_available = epub["isAvailable"]
			end

			def to_hash
				{"is_epub_available" => self.is_available}
			end
		end
	end
end
