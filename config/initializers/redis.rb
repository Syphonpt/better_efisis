$redis = Redis.new(:host => 'localhost', :port => 6379)
$redis.set('timeLater',0)
$redis.set('timeTomorow',0)
$redis.set('timeSomeday',0)
