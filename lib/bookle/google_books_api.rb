# OpenSSL::SSL::SSLError: SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed
# Solution to SSL problem on Windows:
# https://gist.github.com/867550
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

			attr_reader :total_volumes, :volumes, :volume, :raw_response

			attr_accessor *(GOOGLE_QUERY_KEYWORDS.keys + GOOGLE_OPTIONAL_PARAMETERS.keys).map{|method_name| method_name.to_sym} << :google_books_api_key

		  # Instantiates the API for a given Google key.
		  # 
		  # @param [String, #read] -- Google API key.
		  # @return [Google::Books::API] -- An API to interact with the Google Books API.
			def initialize(google_books_api_key)
				@google_books_api_key = google_books_api_key
				@total_volumes				= 0
				@volumes 							= []
			end

		  # Returns a list of accessors that can be used to set the search criteria.
		  # 
		  # @return [Array] -- A list of accessors that can be used to set the search criteria.
			def search_accessors
				GOOGLE_QUERY_KEYWORDS.keys + GOOGLE_OPTIONAL_PARAMETERS.keys
			end

		  # Clears the search criteria.
			def clear_search_options
				search_accessors.each do |method_name|
					__send__ "#{method_name}=".to_sym, nil
				end

				nil
			end

			# Builds and also lets users query the URI string used to interact with the Google API.
			def uri_string
				"https://www.googleapis.com/books/v1/volumes?key=#{@google_books_api_key}#{build_optional_parameters}&q=#{build_query_options}"
			end

			# Runs the search against the Google API.
			#
		  # @return [Array] -- An array of volumes (or what the Google API calls "items").
			def search
				google_response	= nil
				uri 						= URI(uri_string)
				http 						= Net::HTTP.new(uri.host, uri.port)
				http.use_ssl 		= uri.scheme == 'https'
				http.ca_file 		= cacert_path

				http.start {http.request_get("#{uri.path}?#{uri.query}") {|response| @raw_response = response.body}}

				items 					= Google::Books::Items.new(@raw_response)

				@total_volumes 	= items.total_items || 0
				@volumes 				= items.items 			|| []
				@volume 				= volumes.first

				items
			end


			# Updates the SSL certificates file.
			#
		  # @return [String] -- Either a successful message or an error explanation.
			def update_cacert_file
				# cacert = certification authority certificates
				file_path = cacert_path

				Net::HTTP.start("curl.haxx.se") do |http|
				  resp = http.get("/ca/cacert.pem")

				  if resp.code == "200"
				  	File.delete("#{file_path}_old") if File.exists?("#{file_path}_old")
				  	File.rename(file_path, "#{file_path}_old")
				  	File.open(file_path, "w") {|file| file.write(resp.body)}

				    puts "\n\nAn updated version of the file with the certfication authority certificates has been installed to"
				    puts "#{cacert_path}\n\n"
				  else
				    puts "\n\nUnable to download a new version of the certification authority certificates.\n"
				  end
				end
			rescue => e
				puts "\n\nErrors were encountered while updating the certification authority certificates file.\n"

				unless File.exists?(file_path)
					if File.exists?("#{file_path}_old")
						File.rename("#{file_path}_old", file_path)
					else
						puts "\nThe certification authority certificates file could not be found nor restored.\n"
					end
				end

				puts "\nError information:\n"
				puts e.message
			end


			private

				# Returns a string with optional parameters that the URI string uses to query the Google API.
				#
			  # @return [String] -- A string with optional parameters that the URI string uses to query the Google API.
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

				# Returns a string with the query string that the URI string uses to query the Google API.
				#
			  # @return [String] -- A string with the query string that the URI string uses to query the Google API.
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

				# Returns the full path of where the cacert file lives.
				#
			  # @return [String] -- The full path of where the cacert file lives.
				def cacert_path
					File.dirname(`gem which bookle`.chomp) + '/cacert/cacert.pem'
				end

		end
	end
end
