require 'betfair/api'
require 'betfair/api_web'

module Betfair
	 module Helpers
			def self.parse_runners(runners)
				 books = Array.new

				 runners['runners'].each do |r|
						selection_id = Selection.find_by(market_id: runners['marketId'], selection_id: r['selectionId']).id
						r['ex']['availableToBack'].each do |eb|
							 book							 = Book.new
							 book.price				 = eb['price']
							 book.size				 = eb['size']
							 book.side				 = 'BACK'
							 book.selection_id = selection_id

							 books << book
						end

						r['ex']['availableToLay'].each do |el|
							 book							 = Book.new
							 book.price				 = el['price']
							 book.size			   = el['size']
							 book.side				 = 'LAY'
							 book.selection_id = selection_id

							 books << book
						end
				 end

				 return books
			end

	 end
end
