class OddsWorker
	 include Sidekiq::Worker
	 include Sidetiq::Schedulable

	 recurrence { hourly.minute_of_hour(0,5,10,15,20,25,30,35,40,45,50,55) }
	 
	 Sidetiq.logger = Logger.new(STDOUT)

	 def time(range)
			timestamp = 0

			case range
				 when 'later'
						value = 600
						timestamp = $redis.get(range).to_i
				 when 'tomorow'
						value = 1800
						timestamp = $redis.get(range).to_i
				 when 'someday'
						value = 3600
						timestamp = $redis.get(range).to_i
			end

			diference = Time.now.to_i - timestamp

			if diference > value
				 $redis.set(range,Time.now.to_i)
				 return true
			else
				 return false
			end
	 end



	 def perform
			api_account = User.where(auth: 1).first.account.where(service: 'betfair').first
			creds				= { 'username' => api_account.username, 'password' => api_account.password}

#			Event.starting_now.each do |e|
#				 if e.market.not_monitored
#						MonitorAPIWorker.perform_async(creds,e.id)
#						MonitorWEBWorker.perform_async(creds,e.id)
#				 end
#			end

			Event.starting_soon.each	  { |e| RefreshOddsWorker.perform_async(creds,e.id) }
			Event.starting_later.each	  { |e| RefreshOddsWorker.perform_async(creds,e.id) } if time('later')
			Event.starting_tomorow.each { |e| RefreshOddsWorker.perform_async(creds,e.id) } if time('tomorow')
			Event.starting_someday.each { |e| RefreshOddsWorker.perform_async(creds,e.id) } if time('someday')
	 end
end
