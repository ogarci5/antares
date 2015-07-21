module Karen
  module Slack
    # Loading scheme, can either be from file or from an API source.
    def self.load!
      channels = Karen::Slack::API.call('channels.list')['channels']
      users = Karen::Slack::API.call('users.list')['members']
      ims = Karen::Slack::API.call('im.list')['ims']

      Karen::Redis.set 'slack:channels', channels.map { |channel| channel['id'] }
      channels.each do |channel|
        Karen::Redis.set("slack:channels:#{channel['id']}", channel)
      end

      Karen::Redis.set 'slack:users', users.map { |user| user['id'] }
      users.each do |user|
        Karen::Redis.set("slack:users:#{user['id']}", user)
      end

      Karen::Redis.set 'slack:ims', ims.map { |im| im['id'] }
      ims.each do |im|
        Karen::Redis.set("slack:ims:#{im['id']}", im)
      end
    end

    def self.models
      %w(channels users ims).map { |model| "#{to_s}::#{model.classify}".constantize }
    end
  end
end