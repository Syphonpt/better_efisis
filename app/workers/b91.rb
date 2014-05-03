class B91Worker
	 include Sidekiq::Worker

# i got 91 problems but a bitch anit one
# tigrao

	 def perform()
			event_array	  = Array.new
			account_array = Array.new

			$redis.keys("event-web-monitor*").each do |k|
				 if k['time_elapsed'] >= 90
						event_array << {	:id					 => k['id'],
															:home_id		 => k['runner_name'],
															:away_id		 => k['runner_name'],
															:home_score  => k['home_score'],
															:away_score  => k['away_score'],
															:total_score => k['home_score'] + k['away_score']
													 }
				 end
			end

			unless event_array.size == 0
				 total_score = event_array.first['total_score']+0.5
				 market =  Event.find(event_array.first[:id]).market.where(name: "Over/Under #{total_score} Goals").first.id

				 Account.where(service: 'betfair').where(b91: true).each do |u|
						api_account = User.where(auth: 1).first.account.where(service: 'betfair').first
						api					= Betfair::API.new(api_account.username, api_account.password)
				 end
			end


#			selection = Book.
     
			api.place_order(market,selection,'BACK',size,2.0)
	 end
end
