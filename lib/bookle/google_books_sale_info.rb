module Google
	module Books
		class SaleInfo
		  attr_reader :country, :saleability, :is_ebook

		  def initialize(sale_info)
		  	if sale_info
			    @country      = sale_info["country"]
			    @saleability  = sale_info["saleability"]
			    @is_ebook 		= sale_info["isEbook"]
			  end
		  end
		end
	end
end
