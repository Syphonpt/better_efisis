require 'sidekiq/web'

Better::Application.routes.draw do
	 mount Sidekiq::Web => '/sidekiq'
end
