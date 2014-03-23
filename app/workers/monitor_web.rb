class MonitorWEBWorker
	 include Sidekiq::Worker

	 def perform()
			Sidetiq.logger.info "MONITOR WEB WORKER"
	 end
end
