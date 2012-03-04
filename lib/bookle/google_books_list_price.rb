require 'bookle/google_books_price'

module Google
	module Books
		class ListPrice < Google::Books::Price

			def to_hash
				{"list_price_amount" => self.amount, "list_price_currency_code" => self.currency_code}
			end

		end
	end
end
