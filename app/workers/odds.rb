class OddsWorker
	 include Sidekiq::Worker
	 include Sidetiq::Schedulable

	 recurrence { minutely.second_of_minute(0,30) }
	 
	 Sidetiq.logger = Logger.new(STDOUT)

	 def time(range)
			timestamp = 0

			case range
				 when 'soon'
						value = 300
						timestamp = $redis.get(range).to_i

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
						MonitorWEBWorker.perform_async(e.id)

						e.monitored = true
						e.save
				 end
			end

			Event.starting_now.each		  { |e| RefreshOddsWorker.perform_async(e.id) }
			Event.starting_soon.each	  { |e| RefreshOddsWorker.perform_async(e.id) } if time('soon')
			Event.starting_later.each	  { |e| RefreshOddsWorker.perform_async(e.id) } if time('later')
			Event.starting_tomorow.each { |e| RefreshOddsWorker.perform_async(e.id) } if time('tomorow')
			Event.starting_someday.each { |e| RefreshOddsWorker.perform_async(e.id) } if time('someday')
	 end
end
