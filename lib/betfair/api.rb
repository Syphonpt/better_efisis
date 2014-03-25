module Betfair

	 CERT_ENDPOINT = 'https://identitysso.betfair.com/api/certlogin'
	 KEEP_ENDPOINT = 'https://identitysso.betfair.com/api/keepAlive'
	 JSON_ENDPOINT = 'https://api.betfair.com/'
	 JSON_URL		   = '/exchange/betting/json-rpc/v1/'
	 JSON_ACC_URL  = '/exchange/account/json-rpc/v1/'

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

			def api_call(param,header = std_header)
				 connection = Faraday.new(JSON_ENDPOINT, :headers => header ) do |b|
						b.request		:json
						b.response	:raise_error
						b.response	:json, :content_type => ACCEPT
						b.adapter		Faraday.default_adapter
				 end

				 response = connection.put(JSON_URL,param)

				 return response
			end



			# Devolve uma lista de todos os campeonatos com a quantidade de mercados existentes
			# https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/listCountries
			def get_competitions
				 header = {
						'jsonrpc'=> '2.0',
						'method' => 'SportsAPING/v1.0/listCompetitions',
						'params' => {
							 'filter' => {
									'exchangeIds'	 => ['1']
							 }
						}
				 }


				 response = api_call(header)
				 response.body
			end

			# Devolve uma lista de todos os paises com a quantidade mercados existente
			# https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/listCompetitions
			def get_countries
				 header = {
						'jsonrpc'=> '2.0',
						'method' => 'SportsAPING/v1.0/listCountries',
						'params' => {
							 'filter' => {
									'exchangeIds'	 => ['1']
							 }
						}
				 }

				 response = api_call(header)
				 response.body
			end

			# Devolve uma lista de todos os eventos
			# https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/listEvents
			# TODO
			# => ver o que acontece quando se perde a ligaçao
			def get_all_events
				 header = {
						'jsonrpc'=> '2.0',
						'method' => 'SportsAPING/v1.0/listEvents',
						'params' => { 
							 'filter' => { 
									'exchangeIds'			=> ['1'],
									'eventTypeIds'		=> ['1'],
									'bspOnly'					=> 'false',
									'marketStartTime' => {
										 'from' => 1.hour.from_now,
										 'to' => 2.days.from_now
									}
							 } 
						}
				 }


				 response = api_call(header)
				 response.body
			end


			# Devolve uma lista estática com informação dos mercados
			# https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/listMarketCatalogue
			# TODO
			#
			def get_market_catalogue(event_id)
				 event_id = [event_id] unless event_id.class == Array

				 header = {
						'jsonrpc'=> '2.0',
						'method' => 'SportsAPING/v1.0/listMarketCatalogue',
						'params' => {
							 'filter' => { 
									'eventIds' => event_id,
							 },
#							 'marketProjection' => ['RUNNER_METADATA'], 
							 'maxResults' => 999 
						}
				 }

				 response = api_call(header)
				 response.body
			end

			def get_market_book(market_id)
				 market_id = [market_id] unless market_id.class == Array
				 header = {
						'jsonrpc'=> '2.0',
						'method' => 'SportsAPING/v1.0/listMarketBook',
						'params' => {
							 'marketIds' => market_id,
							 'priceProjection' => {
									'priceData' => ['EX_ALL_OFFERS'],
									'virtualise' => false,
									'rolloverStakes' => false
							 },
							 'currencyCode' => 'EUR'
						}
				 }

				 response = api_call(header)
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

			def list_current_orders(bet = nil, market = nil)
				 raise 'format error' unless bet.class == NilClass or bet.class == Array
				 raise 'format error' unless market.class == NilClass or market.class == Array


 				 header = {
						'jsonrpc'=> '2.0',
						'method' => 'SportsAPING/v1.0/listCurrentOrders',
						'params' => {}
				 }

				 header['params'].store('betIds',bet) unless bet == nil
				 header['params'].store('marketIds',market) unless market == nil

				 response = api_call(header)
				 response.body

			end

			def place_order(market,selection,side,size,price)
				 raise 'format error' unless market.class == String
#				 raise 'format error' unless selection.class == Integer
				 raise 'format error' unless side == 'BACK' or side == 'LAY'
				 raise 'format error' unless size.class == String
#				 raise 'format error' unless price.class == Integer

				 header = {
						'jsonrpc'=> '2.0',
						'method' => 'SportsAPING/v1.0/placeOrders',
						'params' => { 
							 'marketId'			=> market, #
							 'instructions'  => [{
									'selectionId'=> selection,
									'side'			  => side,
									'orderType'  => 'LIMIT',
									'limitOrder' => {
										 'size'						=> size,
										 'price'						=> price,
										 'persistenceType' => 'LAPSE'
									}
							 }]
						} 
				 }


				 response = api_call(header)
				 response.body
			end

			def update_order
			end

			def cancel_order
			end

			def get_account_details
			end

			def get_account_funds
				 header = {
						'jsonrpc'=> '2.0',
						'method' => 'AccountAPING/v1.0/getAccountFunds',
				 }

				 connection = Faraday.new(JSON_ENDPOINT, :headers => std_header ) do |b|
						b.request		:json
						b.response	:raise_error
						b.response	:json, :content_type => ACCEPT
						b.adapter		Faraday.default_adapter
				 end

				 response = connection.put(JSON_ACC_URL,header)
				 response.body
			end

			# Faz o login do utilizador e retorna o session token
			# https://api.developer.betfair.com/services/webapps/docs/display/1smk3cen4v3lu3yomq5qye0ni/Non-Interactive+%28bot%29+login
			# TODO 
			#      => error handling quando a ligação falha
			#      => limpar codigo
			def login(user,pass)

				 if Account.betfair_valid_ssoid(user,pass)
						ssoid = Account.betfair_get_ssoid(user,pass).first.ssoid
						return ssoid

				 else
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

						ssoid = JSON.parse(resp.body)['sessionToken']

						account			  = Account.betfair_by_creds(user,pass).first
						account.time  = Time.now.to_i
						account.ssoid = ssoid
						account.save

						return ssoid 
				 end
			end


			def initialize(u,p)
				 @ssoid = login(u,p)
			end
	 end
end
