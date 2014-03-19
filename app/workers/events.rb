class EventWorker
   include Sidekiq::Worker
   include Sidetiq::Schedulable

   Sidetiq.logger = Logger.new(STDOUT)
	 Sidekiq.options[:poll_interval] = 1 

	 recurrence do
#	daily.hour_of_day(18)
			hourly.minute_of_hour(28)
	 end

   def perform
			api_account = User.where(auth: 1).first.account.where(service: 'betfair').first

			api			 = Betfair::API.new(api_account.username, api_account.password)
			markets	 = Array.new
			events	 = Array.new

			api.get_all_events['result'].each do |e|
				 if e.valid_event?
						events << Event.new(	 id:			   e['event']['id'],
													 name:		   e['event']['name'],
													 cc:			   e['event']['countryCode'],
													 open_date:	 DateTime.parse(e['event']['openDate']),
													 status:	   'unknown' )

						if e['marketCount'] > 0
							 api.get_market_catalogue(e['event']['id'])['result'].each do |m|
									markets << Market.new(	 market_id:			m['marketId'],
																						 event_id:			e['event']['id'],
																						 name:					m['marketName'],
																						 total_matched: m['totalMatched'],
																						 has_worker:		false,
																						 status:				'unknown')

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
