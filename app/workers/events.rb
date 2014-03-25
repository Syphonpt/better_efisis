class EventWorker
   include Sidekiq::Worker
   include Sidetiq::Schedulable

   Sidetiq.logger = Logger.new(STDOUT)
	 Sidekiq.options[:poll_interval] = 1 

	 recurrence do daily.hour_of_day(02) end

   def perform
			api_account = User.where(auth: 1).first.account.where(service: 'betfair').first

			api			 = Betfair::API.new(api_account.username, api_account.password)
			markets	 = Array.new
			events	 = Array.new

			api.get_all_events['result'].each do |e|
				 if e.valid_event?
						event					  = Event.new
						event.id			  = e['event']['id']
						event.name		  = e['event']['name']
						event.cc			  = e['event']['countryCode']
						event.open_date = DateTime.parse(e['event']['openDate'])
						event.status	  = 'not started'
						event.monitored = false

						events << event

						if e['marketCount'] > 0
							 api.get_market_catalogue(e['event']['id'])['result'].each do |m|
									market						   = Market.new
									market.market_id		 = m['marketId']
									market.event_id			 = e['event']['id']
									market.name					 =	m['marketName']
									market.total_matched = m['totalMatched']
									market.status				 = 'unknown'

									markets << market

							 end
						end

				 else
						Sidetiq.logger.error "invalid event "+e.to_s
				 end
			end

			Event.import(events)
			Market.import(markets)

   end
end
