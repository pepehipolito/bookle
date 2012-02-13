# OpenSSL::SSL::SSLError: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
# def search(isbn='9780140196092')

require 'net/https'
require 'bookle/google_books_items'

module Google
	module Books
		class API
			GOOGLE_SEARCH_KEYWORDS = {
				'in_title'			=> 'intitle',
				'in_author'			=> 'inauthor',
				'in_publisher'	=> 'inpublisher',
				'in_subject'		=> 'subject',
				'isbn'					=> 'isbn',
				'lccn'					=> 'lccn',
				'oclc'					=> 'oclc'
			}
			SCHEME 						= 'https'
			HOST 							= 'www.googleapis.com'
			PATH 							= 'books/v1/volumes'
			KEY_PARAM_NAME		= 'key'
			QUERY_MARKER			= 'q'
			ISBN_MARKER				= 'isbn'
			KEYWORD_SEPARATOR = '+'

			attr_writer :google_books_api_key

			attr_reader :books, :book, :search_options, :raw_response

			attr_accessor :cacert_path		# cacert = certification authority certificates

			def initialize(google_books_api_key)
				@google_books_api_key = google_books_api_key
				@cacert_path 					= 'lib/cacert/cacert.pem'
				@search_options 			= {}
			end

			# Prefixed some of the keywords with 'in_' to convey the Google meaning that the value is found *in* the content.
			# Google differentiates between *in* content and *is* content.
			def search_keywords
				GOOGLE_SEARCH_KEYWORDS.keys
			end

			def set_search_option(keyword, value)
				if search_keywords.include? keyword.to_s
					@search_options[keyword.to_s] = value.to_s
				end
			end

			def build_search_values
				search_values = ''

				@search_options.each do |key, value|
					if search_keywords.include? key
						search_values += KEYWORD_SEPARATOR unless search_values.nil? || search_values.strip.empty?
						search_values += "#{GOOGLE_SEARCH_KEYWORDS[key]}:#{URI.escape(value.to_s)}"		# Need to escape values or search might fail.
					end
				end

				search_values
			end

			# Build and also let the user query the string.
			def uri_string
				"#{SCHEME}://#{HOST}/#{PATH}?#{KEY_PARAM_NAME}=#{@google_books_api_key}&#{QUERY_MARKER}=#{build_search_values}"
			end

			# The Google Books API builds its query using 'OR', not 'AND'. That means that the more keywords used during the search
			# the wider the range of results.
			# When search options are passed to this method prior search options set with the set_search_option method will be disregarded.
			# def search(isbn='9780140196092')
			def search(options={})
				raise "The search method only accepts a Hash object." unless search_options.class == Hash

				# Replace search options if options passed.
				unless options.empty?
					@search_options.clear
					options.each {|key, value| set_search_option(key, value)}
				end

				raise "No search options have been set yet." if @search_options.empty?

				google_response	= nil
				uri 						= URI(uri_string)
				http 						= Net::HTTP.new(uri.host, uri.port)
				http.use_ssl 		= uri.scheme == 'https'
				http.ca_file 		= @cacert_path

				http.start {http.request_get("#{uri.path}?#{uri.query}") {|response| @raw_response = response.body}}

				items 	= Google::Books::Items.new(@raw_response)
				@books 	= items.items || []
				@book  	= books.first

				items
			end

		end
	end
end

# q 	Full-text query string.

#     When creating a query, list search terms separated by a '+', in the form q=term1+term2_term3.
#     (Alternatively, you can separate them with a space, but as with all of the query parameter values,
#     the spaces must then be URL encoded.)
#     The API returns all entries that match all of the search terms (like using AND between terms).
#     Like Google's web search, the API searches on complete words (and related words with the same stem), not substrings.
#     To search for an exact phrase, enclose the phrase in quotation marks: q="exact phrase".
#     To exclude entries that match a given term, use the form q=-term.
#     The search is case-insensitive.
#     Example: to search for all entries that contain the exact phrase "Elizabeth Bennet" and the word "Darcy"
#     but don't contain the word "Austen", use the following query parameter value:
#     q="Elizabeth+Bennet"+Darcy-Austen
#     There are special keywords you can specify in the search terms to search in particular fields, such as:
#         intitle: Returns results where the text following this keyword is found in the title.
#         inauthor: Returns results where the text following this keyword is found in the author.
#         inpublisher: Returns results where the text following this keyword is found in the publisher.
#         subject: Returns results where the text following this keyword is listed in the category list of the volume.
#         isbn: Returns results where the text following this keyword is the ISBN number.
#         lccn: Returns results where the text following this keyword is the Library of Congress Control Number.
#         oclc: Returns results where the text following this keyword is the Online Computer Library Center number.
