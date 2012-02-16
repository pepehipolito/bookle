# OpenSSL::SSL::SSLError: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
# def search(isbn='9780140196092')
# https://www.googleapis.com/books/v1/volumes?key=AIzaSyAUJ0psGl0udam2kFzT29L2YWAhCF748ik&q=inauthor:keyes&maxResults=40&startIndex=40

require 'net/https'
require 'bookle/google_books_items'

module Google
	module Books
		class API

			GOOGLE_OPTIONAL_PARAMETERS = {
				'start_index_at'	=> 'startIndex',				# starts at 0 (default)
				'maximum_results'	=> 'maxResults'					# [0..40], default=10
			}

			# Prefixed some of the keywords with 'in_' to convey the Google meaning that the value is found *in* the content.
			# Google differentiates between *in* content and *is* content.
			GOOGLE_QUERY_KEYWORDS	= {
				'title'						=> 'intitle',
				'author'					=> 'inauthor',
				'publisher'				=> 'inpublisher',
				'subject'					=> 'subject',						# *in* subject
				'isbn'						=> 'isbn',							# ISBN
				'lccn'						=> 'lccn',							# Library of Congress Control Number
				'oclc'						=> 'oclc'								# Online Computer Library Center number
			}

			attr_reader :volumes, :volume, :raw_response

			# cacert = certification authority certificates
			attr_accessor *(GOOGLE_QUERY_KEYWORDS.keys + GOOGLE_OPTIONAL_PARAMETERS.keys).map{|method_name| method_name.to_sym} << :google_books_api_key

			def initialize(google_books_api_key)
				contents = `gem contents bookle`
				puts contents.class
				puts contents.inspect
				@google_books_api_key = google_books_api_key
				@cacert_path 					= File.dirname(`gem which bookle`.chomp) + '/cacert/cacert.pem'
			end

			def search_accessors
				GOOGLE_QUERY_KEYWORDS.keys + GOOGLE_OPTIONAL_PARAMETERS.keys
			end

			def clear_search_options
				search_accessors.each do |method_name|
					__send__ method_name.to_sym, nil
				end

				nil
			end

			# Build and also let the user query the string.
			# schema 						= https
			# host							= www.googleapis.com`
			# path 							= books/v1/volumes
			# key marker 				= key
			# query marker 			= q
			# keyword separator	= + (used in build_query_options())
			def uri_string
				"https://www.googleapis.com/books/v1/volumes?key=#{@google_books_api_key}#{build_optional_parameters}&q=#{build_query_options}"
			end

			# The Google Books API builds its query using 'OR', not 'AND'. That means that the more keywords used during the search
			# the wider the range of results.
			# When search options are passed to this method prior search options set with the set_search_option method will be disregarded.
			# def search(isbn='9780140196092')
			def search
				google_response	= nil
				uri 						= URI(uri_string)
				http 						= Net::HTTP.new(uri.host, uri.port)
				http.use_ssl 		= uri.scheme == 'https'
				http.ca_file 		= @cacert_path

				http.start {http.request_get("#{uri.path}?#{uri.query}") {|response| @raw_response = response.body}}

				items 		= Google::Books::Items.new(@raw_response)
				@volumes 	= items.items || []
				@volume 	= volumes.first

				items
			end


			private

				def build_optional_parameters
					string = ''

					GOOGLE_OPTIONAL_PARAMETERS.each do |method_name, query_parameter|
						unless __send__(method_name.to_sym).nil?
							# Need to escape values or search might fail due to spaces, etc.
							string += "&#{query_parameter}=#{URI.escape(__send__(method_name.to_sym).to_s)}"
						end
					end

					string
				end

				def build_query_options
					string = ''

					GOOGLE_QUERY_KEYWORDS.each do |method_name, query_keyword|
						unless __send__(method_name.to_sym).nil?
							# Need to escape values or search might fail due to spaces, etc.
							string += "#{query_keyword}:#{URI.escape(__send__(method_name.to_sym).to_s)}+"
						end
					end

					# Return string except for last keyword separator.
					string.chop
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
