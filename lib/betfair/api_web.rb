module Betfair

	 module API_WEB

			APIWEB_URL = 'http://www.betfair.com/inplayservice/v1.1/'

			def self.get_event_timeline(event_id)
				 url = APIWEB_URL + 'eventTimeline?alt=json&locale=en_GB&eventId=' + event_id.to_s

				 connection = Faraday.new(url) do |b|
						b.response	:raise_error
						b.response	:json, :content_type => ACCEPT
						b.adapter		Faraday.default_adapter
				 end

				 return connection.get

			end
	 end

end
