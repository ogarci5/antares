Karen.configure do |config|
  config.user = User.admin
  config.redis = Resque.redis
end