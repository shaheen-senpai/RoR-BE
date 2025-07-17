require 'flipper'
require 'flipper/adapters/redis'

Flipper.configure do |config|
  config.default do
    redis = Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'))
    adapter = Flipper::Adapters::Redis.new(redis)
    Flipper.new(adapter)
  end
end
