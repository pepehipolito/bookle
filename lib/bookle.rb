require 'bookle/google_books_api'

# Enables Ruby code interact with the Google Books API.
class Bookle

	# Returns an instance of the class that interacts with the Google Books API.
	#
  # @return [Google::Books::API] -- An instance of the class that interacts with the Google Books API.
	def self.api(google_books_api_key)
		Google::Books::API.new(google_books_api_key)
	end

end
