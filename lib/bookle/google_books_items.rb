require 'json'
require 'bookle/google_books_item'

module Google
	module Books
		class Items
			attr_reader :kind, :total_items, :items

			def initialize(google_response)
				books_info 	= JSON.parse(google_response)

				@kind 				= books_info["kind"]
				@total_items 	= books_info["totalItems"] || 0

				if books_info["items"]
					@items = books_info["items"].collect {|item| Google::Books::Item.new(item)}
				else
					@items = []
				end
			end
		end
	end
end
