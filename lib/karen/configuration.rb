module Karen
  class Configuration
    OPTIONS = [:user, :redis]

    # Configuration option getters and setters
    class << self
      attr_accessor *OPTIONS
    end

    def initialize(&config)
      config.call(self.class)
    end
  end
end