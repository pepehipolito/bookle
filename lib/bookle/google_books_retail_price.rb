require 'bookle/google_books_price'

module Google
	module Books
		class RetailPrice < Google::Books::Price

			def to_hash
				{"retail_price_amount" => self.amount, "retail_price_currency_code" => self.currency_code}
			end
		end
	end
end
