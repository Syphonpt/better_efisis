require 'betfair/api'
require 'betfair/api_web'

module Betfair
	 module Helpers
			def self.parse_runners(runners)
				 books = Array.new

				 runners['runners'].each do |r|
						r['ex']['availableToBack'].each do |eb|
							 book							 = Book.new
							 book.price				 = eb['price']
							 book.size					 = eb['size']
							 book.market_id		 = runners['marketId']
							 book.selection_id  = r['selectionId']

							 books << book
						end

						r['ex']['availableToLay'].each do |el|
							 book							 = Book.new
							 book.price				 = el['price']
							 book.size				   = el['size']
							 book.market_id		 = runners['marketId']
							 book.selection_id  = r['selectionId']

							 books << book
						end
				 end

				 return books
			end


	 end
end
