class HardWorker
  include Sidekiq::Worker

  def perform(name, count)
    puts 'Doing hard work for '+name
  end
end
