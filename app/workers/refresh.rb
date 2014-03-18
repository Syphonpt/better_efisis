class RefreshOddsWorker
	 include Sidekiq::Worker

	 def perform(creds,event_id)

			api					 = Betfair::API.new( creds['username'], creds['password'])
			market			 = Market.where(:event_id => event_id)
			books				 = Array.new
			market_array = Array.new

			market.each do |m|
				 market_array << m.market_id
			end

			market_array.in_groups_of(10) do |m|
			results = api.get_market_book(m)

			if results['result'].size > 0 

				 results['result'].each do |runners|
						runners['runners'].each do |r|

							 r['ex']['availableToBack'].each do |eb|
									books << Book.new(:price => eb['price'],
																		:size => eb['size'],
																		:market_id => runners['marketId'],
																		:selection_id => r['selectionId'])
							 end

							 r['ex']['availableToLay'].each do |el|
									books << Book.new(:price => el['price'],
																		:size => el['size'],
																		:market_id => runners['marketId'],
																		:selection_id => r['selectionId'])
							 end
						end
				 end


				 Book.import(books)
				 end

			end
	 end
end
