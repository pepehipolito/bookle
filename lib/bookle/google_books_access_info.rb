require 'bookle/google_books_epub'
require 'bookle/google_books_pdf'

module Google
	module Books
		class AccessInfo
			attr_reader :access_country, :viewability, :embeddable, :public_domain, :text_to_speech_permission, :epub, :pdf, :web_reader_link,
				:access_view_status

			def initialize(access_info)
				if access_info
					@access_country 						= access_info["country"]
					@viewability 								= access_info["viewability"]
					@embeddable 								= access_info["embeddable"]
					@public_domain 							= access_info["publicDomain"]
					@text_to_speech_permission 	= access_info["textToSpeechPermission"]
					@epub 											= Google::Books::Epub.new(access_info["epub"])
					@pdf 												= Google::Books::Pdf.new(access_info["pdf"])
					@web_reader_link 						= access_info["webReaderLink"]
					@access_view_status 				= access_info["accessViewStatus"]
				end
			end

		end
	end
end
