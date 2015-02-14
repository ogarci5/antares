module Karen

  def self.user
    User.admin
  end

  def self.redis
    Resque.redis
  end
end