module Google
	module Books
		class IndustryIdentifier
			attr_reader :type, :identifier

			def initialize(identifier)
				identifier 	= {} unless identifier
				@type 			= identifier["type"]
				@identifier = identifier["identifier"]
			end

			def to_hash
				{self.type.downcase => self.identifier}
			end
		end
	end
end
