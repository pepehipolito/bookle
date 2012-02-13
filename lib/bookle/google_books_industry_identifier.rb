module Google
	module Books
		class IndustryIdentifier
			attr_reader :type, :identifier

			def initialize(identifier)
				@type 			= identifier["type"]
				@identifier = identifier["identifier"]
			end

		end
	end
end
