module Google
	module Books
		class ImageLinks
			attr_reader :small_thumbnail, :thumbnail

			def initialize(image_links)
        image_links = {} unless image_links
				@small_thumbnail 	= image_links["smallThumbnail"]
				@thumbnail 				= image_links["thumbnail"]
			end
		end
	end
end
