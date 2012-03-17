module Google
	module Books
		class Price
			attr_reader :amount, :currency_code

			def initialize(price)
        price           = {} unless price
				@amount					= price["amount"]
				@currency_code	= price["currencyCode"]
			end
		end
	end
end
