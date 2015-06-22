module Karen
  class Configuration
    OPTIONS = [:user, :redis, :settings]

    # Configuration option getters and setters
    class << self
      attr_accessor *OPTIONS
    end

    def initialize
      yield self.class
    end
  end
end