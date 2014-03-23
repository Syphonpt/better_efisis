class MonitorAPIWorker
	 include Sidekiq::Worker

	 def perform(id)
			api_account  = User.where(auth: 1).first.account.where(service: 'betfair').first
			api					 = Betfair::API.new( api_account.username, api_account.password)

			market = Market.where(event_id: id)
			books  = Array.new

			retry_count   = 0

			market.each do |m| market_array << m.market_id end

			while true
				 break if retry_count == 3
				 break if market_array.size == 0

				 market_info = api.get_market_book(market_array)

				 if market_info['result'].size == 0
						retry_count += 1

				 else
						market_info['result'].each_with_index do |runners,index|

							 case runners['status']
									when 'OPEN'
										 retry_count = 0
										 books = Betfair::Helpers.parse_runners(runners)

									when 'INACTIVE'
										 market_array.delete_at(index)

									when 'SUSPENDED'
										 next

									when 'CLOSED'
										 market_array.delete_at(index)
							 end

						end

						Book.import(books)
						books.clear
						sleep 0.5
				 end
			end

			Market.update(id, status: 'CLOSED')
	 end

end
