require 'bookle/google_books_api'

class Bookle
	# def self.api(google_books_api_key=nil)
	def self.api(google_books_api_key='AIzaSyAUJ0psGl0udam2kFzT29L2YWAhCF748ik')
		Google::Books::API.new(google_books_api_key)
	end
end
