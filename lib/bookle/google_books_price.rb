module Google
	module Books
		class Price
			attr_reader :amount, :currency_code

			def initialize(price)
				if price
					@amount					= list_price["amount"]
					@currency_code	= list_price["currency_code"]
				end
			end

		end
	end
end
