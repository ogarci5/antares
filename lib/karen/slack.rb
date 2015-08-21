module Karen
  module Slack
    # Loading scheme, can either be from file or from an API source.
    def self.load!
      channels = Karen::Slack::API.call('channels.list')['channels']
      users = Karen::Slack::API.call('users.list')['members']
      ims = Karen::Slack::API.call('im.list')['ims']

      users.each do |user|
        Karen::Slack::SlackUser.create(user)
      end

      channels.each do |channel|
        Karen::Slack::Channel.create(channel)
      end

      ims.each do |im|
        i = Karen::Slack::Im.new(im)
        i.user_id = im['user']
        i.save
      end
    end

    def self.models
      %w(channels slack_users ims).map { |model| "karen/slack/#{model}".classify.constantize }
    end
  end
end