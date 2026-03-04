REDIS_URL = ENV.fetch('REDIS_URL', 'redis://redis:6379/0')

begin
	$redis = Redis.new(url: REDIS_URL)
	$redis.ping
rescue Redis::BaseError => e
	Rails.logger.error("Redis init failed: #{e.class} - #{e.message}")
	$redis = nil
end
