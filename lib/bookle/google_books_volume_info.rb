require 'bookle/google_books_industry_identifier'
require 'bookle/google_books_image_links'

module Google
	module Books
		class VolumeInfo
			attr_reader :title, :subtitle, :authors, :publisher, :published_date, :description, :industry_identifiers, :page_count,
				:print_type, :categories, :average_rating, :ratings_count, :content_version, :image_links, :language, :preview_link,
				:info_link, :canonical_volume_link

			def initialize(volume_info)
				if volume_info
					@title 									= volume_info["title"]
					@subtitle 							= volume_info["subtitle"]
					@authors  							= volume_info["authros"]
					@publisher 							= volume_info["publisher"]
					@published_date 				= volume_info["published_date"]
					@description 						= volume_info["description"]
					@industry_identifiers 	= volume_info["industryIdentifiers"].collect do
																			|i| Google::Books::IndustryIdentifier.new(i)
																		end if volume_info["industryIdentifiers"]
					@page_count 						= volume_info["pageCount"]
					@print_type 						= volume_info["printType"]
					@categories 						= volume_info["categories"]
					@average_rating 				= volume_info["averageRating"]
					@ratings_count 					= volume_info["ratingsCount"]
					@content_version 				= volume_info["contentVersion"]
					@image_links 						= Google::Books::ImageLinks.new(volume_info["imageLinks"])
					@language 							= volume_info["language"]
					@preview_link 					= volume_info["previewLink"]
					@info_link 							= volume_info["infoLink"]
					@canonical_volume_link 	= volume_info["canonicalVolumeLink"]
				end
			end
		end
	end
end
