Karen.configure do |config|
  config.user = User.admin

  uri = URI.parse(ENV['REDIS_URL'] || 'redis://localhost:6379/')
  config.redis = Redis::Namespace.new(:karen, redis: Redis.new(host: uri.host, port: uri.port, thread_safe: true))
  Ohm.redis = Redic.new(ENV['REDIS_URL'] || 'redis://localhost:6379/')

  config.services = [Karen::Slack, Karen::Notification, Karen::Runescape]
end