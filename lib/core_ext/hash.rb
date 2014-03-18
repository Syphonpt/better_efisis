class Hash
	 def valid_event?
			event_name	= self['event']['name'].scan(/^(.*)\sv\s(.*)$/).flatten.size
			event_cc		= self['event']['countryCode'] != nil

			if ((event_cc != nil and event_name != 2) or ( event_cc == nil and event_name != 2))
				 false
			else
				 true
			end			
	 end

end
