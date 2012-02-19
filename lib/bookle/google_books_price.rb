module Google
	module Books
		class Price
			attr_reader :amount, :currency_code

			def initialize(price)
				if price
					@amount					= price["amount"]
					@currency_code	= price["currency_code"]
				end
			end

		end
	end
end
