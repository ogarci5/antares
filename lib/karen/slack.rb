module Karen
  module Slack
    # Loading scheme, can either be from file or from an API source.
    def self.load!
      channels = Karen::Slack::API.call('channels.list')['channels']
      users = Karen::Slack::API.call('users.list')['members']
      ims = Karen::Slack::API.call('im.list')['ims']

      Karen::Redis.set('slack:channels', channels)
      Karen::Redis.set('slack:users', users)
      Karen::Redis.set('slack:ims', ims)
    end

    def self.models
      %w(channels users ims).map { |model| "karen/slack/#{model}".classify.constantize }
    end
  end
end