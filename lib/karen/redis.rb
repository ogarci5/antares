module Karen
  module Redis
    class << self
      def get(key = nil)
        return {} unless Karen.redis
        ActiveSupport::JSON.decode(Karen.redis.get(key.to_s))
      end

      def set(key, value)
        return {} unless Karen.redis
        Karen.redis.set(key, value.to_json)
      end
    end
  end
end