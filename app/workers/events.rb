class EventWorker
   include Sidekiq::Worker
   include Sidetiq::Schedulable

   Sidetiq.logger = Logger.new(STDOUT)
	 Sidekiq.options[:poll_interval] = 1 

	 recurrence do
			daily.hour_of_day(12)
	 end

   def perform
			user				= User.where(auth: 1).first
			api_account = user.account.where(service: 'betfair').first

			api = Betfair::API.new(api_account.username, api_account.password)
			events = api.get_all_events

			events['result'].each do |e|
				 if e.valid_event?
						event					  = Event.new
						event.id			  = e['event']['id']
						event.name		  = e['event']['name']
						event.cc			  = e['event']['countryCode']
						event.open_date = e['event']['openDate']
						event.status	  = 'unknown'

						if e['marketCount'] > 0
							 api.get_market_catalogue(event.id)['result'].each do |m|
									market							 = Market.new
									market.market_id		 = m['marketId']
									market.event_id			 = event.id
									market.name					 = m['marketName']
									market.total_matched = m['totalMatched']
									market.has_worker		 = false
									market.status				 = 'unknown'

									market.save
							 end
						end

						event.save

				 else
						Sidetiq.logger.error "invalid event "+e.to_s
				 end
			end

   end
end
