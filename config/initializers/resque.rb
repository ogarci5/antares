ENV['REDIS_URL'] ||= 'redis://localhost:6379/'

uri = URI.parse(ENV['REDIS_URL'])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :thread_safe => true)

# If you want to be able to dynamically change the schedule,
# uncomment this line.  A dynamic schedule can be updated via the
# Resque::Scheduler.set_schedule (and remove_schedule) methods.
# When dynamic is set to true, the scheduler process looks for
# schedule changes and applies them on the fly.
# Note: This feature is only available in >=2.0.0.
#Resque::Scheduler.dynamic = true

Dir["#{Rails.root}/app/workers/*.rb"].each { |file| require file }