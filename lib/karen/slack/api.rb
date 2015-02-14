module Karen
  module Slack
    class API
      BASE_URL = 'https://slack.com/api/'
      BASE_QUERY = {token: ENV['SLACK_TOKEN']}

      def self.call(api_method, query = {})
        query = query.merge(BASE_QUERY)
        call = Curl.post(BASE_URL+api_method, query)
        ActiveSupport::JSON.decode(call.body)
      end
    end
  end
end