require 'bookle/google_books_list_price'
require 'bookle/google_books_retail_price'

module Google
	module Books
		class SaleInfo
		  attr_reader :sale_country, :saleability, :is_ebook, :list_price, :retail_price, :buy_link

		  def initialize(sale_info)
		  	if sale_info
			    @sale_country = sale_info["country"]
			    @saleability  = sale_info["saleability"]
			    @is_ebook 		= sale_info["isEbook"]
			    @list_price		= Google::Books::ListPrice.new(sale_info["listPrice"])
			    @retail_price = Google::Books::RetailPrice.new(sale_info["retailPrice"])
			    @buy_link			= sale_info["buyLink"]
			  end
		  end

		end
	end
end
