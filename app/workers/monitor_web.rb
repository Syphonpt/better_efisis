class MonitorWEBWorker
	 include Sidekiq::Worker

	 def updates_to_db(event_id,home_id,away_id,updates)
			updates_array = Array.new

			updates.each do |u|
				 update = Update.new
				 update.match_time  = u['matchTime']
				 update.update_type	= u['type']

				 case u['team']
						when nil
							 update.runner_id = nil 
						when 'home'
							 update.runner_id = home_id
						when 'away'
							 update.runner_id = away_id 
				 end

				 update.event_id	 = event_id

				 updates_array << update
			end

			return updates_array
	 end

	 def perform(id)
			home_name		 = nil
			away_name		 = nil
			runner_home  = 0
			runner_away  = 0
			waiting_loop = 0
			started			 = true
			updates			 = nil
			response		 = nil

			while true
				 if waiting_loop == 200
						started = false
						break
				 end

				 response = Betfair::API_WEB.get_event_timeline(id)
				 break unless response.body.size == 0

				 waiting_loop +=1
				 sleep 10
			end

			if started
				 rediskey = "event-web-monitor-#{id}"
				 $redis.set(rediskey,nil)

				 home_name  = response.body['score']['home']['name']
				 away_name  = response.body['score']['away']['name']

				 runner_home = Runner.select(:id).find_by(name: home_name)
				 if runner_home.nil?
						runner_home = Runner.create(name: home_name).id
				 else
						runner_home = runner_home.id
				 end

				 runner_away = Runner.select(:id).find_by(name: away_name)
				 if runner_away.nil?
						runner_away = Runner.create(name: away_name).id
				 else
						runner_away = runner_away.id
				 end

				 Event.update(id, status: "IN_PLAY")

				 while true
						response = Betfair::API_WEB.get_event_timeline(id)

						home_score = response.body['score']['home']['score'] unless response.body['score']['home'].nil?
						away_score = response.body['score']['away']['score'] unless response.body['score']['away'].nil?
			 
						updates = response.body['updateDetails']
						time_elapsed = response.body['timeElapsed']
						match_status = response.body['status']

						hash = { :id						=> id,
										 :home_name			=> home_name, 
										 :home_score		=> home_score,
										 :runner_home		=> runner_home,
										 :away_name			=> away_name,
										 :away_score		=> away_score,
										 :runner_away		=> runner_away,
										 :match_status	=> match_status,
										 :time_elapsed	=> time_elapsed,
										 :updates				=> updates
						}

					 $redis.set(rediskey,ActiveSupport::JSON.encode(hash))
					 sleep 3

					 break if match_status == 'COMPLETE'
					 break if response.body['inPlayMatchStatus'] == 'Finished'
				 end

				 $redis.del(rediskey)
				 Update.import(updates_to_db(id,runner_home,runner_away,updates))
			end

			Event.update(id, status: "ENDED", monitored: false)
	 end
end
