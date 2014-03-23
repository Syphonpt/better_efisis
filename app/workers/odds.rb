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
			Event.starting_now.each do |e|
				 unless e.monitored
#						MonitorWEBWorker.perform_async(e.id)
						MonitorAPIWorker.perform_async(e.id)

						e.monitored = true
						e.save
				 end
			end

			Event.starting_soon.each	  { |e| RefreshOddsWorker.perform_async(e.id) }
			Event.starting_later.each	  { |e| RefreshOddsWorker.perform_async(e.id) } if time('later')
			Event.starting_tomorow.each { |e| RefreshOddsWorker.perform_async(e.id) } if time('tomorow')
			Event.starting_someday.each { |e| RefreshOddsWorker.perform_async(e.id) } if time('someday')
	 end
end
