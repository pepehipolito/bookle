module Google
	module Books
		class SearchInfo
			attr_reader :text_snippet

			def initialize(search_info)
				if search_info
					@text_snippet = search_info["textSnippet"]
				end
			end
		end
	end
end
