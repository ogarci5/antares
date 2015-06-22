module Karen
  module Slack
    # Loading scheme, can either be from file or from an API source.
    def self.load!
      channels = Karen::Slack::API.call('channels.list')['channels']
      users = Karen::Slack::API.call('users.list')['members']
      ims = Karen::Slack::API.call('im.list')['ims']
      Karen::Redis.set(:slack, 'channels' => channels, 'users' => users, 'ims' => ims)
    end

    def self.models
      %i.channels users ims.
    end
  end
end