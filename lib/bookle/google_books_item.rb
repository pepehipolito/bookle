require 'bookle/google_books_volume_info'
require 'bookle/google_books_sale_info'
require 'bookle/google_books_access_info'

module Google
	module Books
		class Item
			attr_reader :kind, :id, :etag, :self_link, :volume_info, :sale_info, :access_info

			def initialize(item)
				@kind 				= item["kind"]
				@id 					= item["id"]
				@etag					= item["etag"]
				@self_link 		= item["selfLink"]
				@volume_info 	= Google::Books::VolumeInfo.new(item["volumeInfo"])
				@sale_info 		= Google::Books::SaleInfo.new(item["saleInfo"])
				@access_info 	= Google::Books::AccessInfo.new(item["accessInfo"])
			end
		end
	end
end
