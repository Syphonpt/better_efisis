class EventWorker
   include Sidekiq::Worker
   include Sidetiq::Schedulable

   Sidetiq.logger = Logger.new(STDOUT)
	 Sidekiq.options[:poll_interval] = 1 

	 recurrence do
			hourly.minute_of_hour(0,10,20,30,40,50)
	 end

   def perform
			user				= User.where(auth: 1).first
			api_account = user.account.where(service: 'betfair').first

			api = Betfair::API.new(api_account.username, api_account.password)
			events = api.get_all_events

			events['result'].each do |e|
				 if e.valid_event?
						event = Event.new
						event.id			  = e['event']['id']
						event.name		  = e['event']['name']
						event.cc			  = e['event']['countryCode']
						event.open_date = e['event']['openDate']

						event.save

				 else
						Sidetiq.logger.info do
							 "invalid event "+e.to_s
						end

				 end
			end

   end
end
