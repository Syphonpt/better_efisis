module Betfair

	 CERT_ENDPOINT = 'https://identitysso.betfair.com/api/certlogin'
	 KEEP_ENDPOINT = 'https://identitysso.betfair.com/api/keepAlive'
	 JSON_ENDPOINT = 'https://api.betfair.com/'
	 JSON_URL		   = '/exchange/betting/json-rpc/v1/'

	 APP_KEY = '8wrkSHO40RaEx5JR'

	 CONTENT_TYPE = 'application/x-www-form-urlencoded'
	 ACCEPT = 'application/json'

	 class API

			attr_accessor :ssoid

			def std_header
				 {
						'X-Authentication' => @ssoid,
						'X-Application' => APP_KEY,
						'Content-Type' => ACCEPT,
				 }
			end

			def event_header
				 {
						'jsonrpc'=> '2.0',
						'method' => 'SportsAPING/v1.0/listEvents',
						'params' => { 
							 'filter' => { 
									'exchangeIds'	 => ['1'],
									'eventTypeIds' => ['1'],
									'bspOnly'			 => 'false'
							 } 
						}
				 }
			end

			def competition_filter_header
				 {
						'jsonrpc'=> '2.0',
						'method' => 'SportsAPING/v1.0/listCompetitions',
						'params' => {
							 'filter' => {
									'exchangeIds'	 => ['1']
							 }
						}
				 }
			end

			def country_filter_header
				 {
						'jsonrpc'=> '2.0',
						'method' => 'SportsAPING/v1.0/listCountries',
						'params' => {
							 'filter' => {
									'exchangeIds'	 => ['1']
							 }
						}
				 }
			end

			def create_faraday_connection(header = std_header)
				 connection = Faraday.new(JSON_ENDPOINT, :headers => header ) do |b|
						b.request		:json
						b.response	:logger
						b.response	:raise_error
						b.response	:json, :content_type => ACCEPT
						b.adapter		Faraday.default_adapter
				 end

				 return connection
			end



			def get_competitions
				 connection = create_faraday_connection

				 response = connection.put(JSON_URL,competition_filter_header)
				 response.body
			end

			def get_countries
				 connection = create_faraday_connection

				 response = connection.put(JSON_URL,country_filter_header)
				 response.body
			end

			# Devolve uma lista de todos os eventos
			# https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/listEvents
			# TODO
			# => ver o que acontece quando se perde a ligaçao
			def get_all_events
				 connection = create_faraday_connection

				 response = connection.put(JSON_URL,event_header)
				 response.body
			end


			# Reinicia o countador do timeout do token
			# https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Keep+Alive
			# TODO 
			# => error handling quando a ligação falha
			# => DRY
			def keep_alive
				 connection = Faraday.new(KEEP_ENDPOINT)
				 resp = connection.post do |req|
						req.headers['Accept'] = ACCEPT
						req.headers['X-Application'] = APP_KEY
						req.headers['X-Authentication'] = @ssoid
				 end

				 resp = JSON.parse(resp.body)

				 case resp['status'] 
						when 'SUCCESS'
							 return resp['token']
						when 'FAIL'
							 return nil
				 end
			end


			# Faz o login do utilizador e retorna o session token
			# https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Non-Interactive+%28bot%29+login
			# TODO 
			#      => error handling quando a ligação falha
			#      => limpar codigo
			def login(user,pass)
				 login_str = "username=#{user}&password=#{pass}"

				 connection = Faraday.new( CERT_ENDPOINT, :ssl => {
						client_cert: OpenSSL::X509::Certificate.new(File.read('./lib/betfair/client-2048.crt')),
						client_key:  OpenSSL::PKey::RSA.new(File.read('./lib/betfair/client-2048.key'))}
				 )

				 resp = connection.post do |req|
						req.headers['Content-Type'] = CONTENT_TYPE 
						req.headers['X-Application'] = APP_KEY
						req.body = login_str
				 end

				 return JSON.parse(resp.body)['sessionToken']
			end

			# Devolve verdadeiro ou falso se se trata de um evento valido ou não
			# TODO
			# => fazer isto um class method ie. Hash.event_valid?
			def event_valid(e)
				 event_name = e['event']['name'].scan(/^(.*)\sv\s(.*)$/).flatten.size
				 event_cc = e['event']['countryCode'] != nil

				 if ((event_cc != nil and event_name != 2) or ( event_cc == nil and event_name != 2))
						false
				 else
						true
				 end
			end


			# Devolve uma lsit de todos os eventos parsed prontos para serem adicionados á base de dados
			# TODO
			# => error handling
			def get_all_events_parsed
				 response_parsed = Array.new

				 get_all_events['result'].each do	|e|
						if event_valid(e)
							 id = e['event']['id']

							 if e['event']['countryCode'] == nil
									cc = 'xx'
							 else
									cc = e['event']['countryCode']
							 end

							 home = e['event']['name'].scan(/^(.*)\sv\s(.*)$/).flatten[0].downcase
							 away = e['event']['name'].scan(/^(.*)\sv\s(.*)$/).flatten[1].downcase
							 a = e['event']['openDate'].scan(/(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})/).flatten!
							 date = Time.new(a[0],a[1],a[2],a[3],a[4],a[5]).to_i

							 response_parsed << {:id => id, :cc => cc, :date => date, :home => home, :away => away }
						end
				 end

				 return response_parsed
			end


			def initialize(u,p)
				 @ssoid = login(u,p)
			end
	 end
end
