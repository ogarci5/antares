module Karen
  module Slack
    class API
      BASE_URL = 'https://slack.com/api/'
      BASE_QUERY = {token: ENV['SLACK_TOKEN']}

      def self.call(api_method, query = {})
        query = query.merge(BASE_QUERY)
        call = RestClient.post(BASE_URL + api_method, query)
        ActiveSupport::JSON.decode(call.body)
      end

      ##
      # Resource methods

      class << self
        def resources(method:, query: {}, key:)
          Karen::Slack::API.call(method, query).fetch(key, [])
        end

        def channels
          resources(method: 'channels.list', key: 'channels')
        end

        def slack_users
          resources(method: 'users.list', key: 'members')
        end

        def ims
          resources(method: 'im.list', key: 'ims')
        end

        def messages(channel:)
          resources(method: channel.method, query: {channel: channel.id, count: 20}, key: 'messages')
        end
      end
    end
  end
end