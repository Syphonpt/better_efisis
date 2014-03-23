class RefreshOddsWorker
	 include Sidekiq::Worker

	 def perform(event_id)
			api_account  = User.where(auth: 1).first.account.where(service: 'betfair').first
			api					 = Betfair::API.new( api_account.username, api_account.password)
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
							 books = Betfair::Helpers.parse_runners(runners)
						end
				 end
			end

			Book.import(books)
	 end
end
