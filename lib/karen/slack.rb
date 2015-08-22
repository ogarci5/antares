module Karen
  module Slack
    # Loading scheme, can either be from file or from an API source.
    def self.load!
      API.slack_users.each { |user| SlackUser.create(user) }
      # Creates Slackbot
      SlackUser.create id: 'USLACKBOT', name: 'slackbot', real_name: 'slackbot'
      API.channels.each { |channel| Channel.create(channel) }
      API.ims.each { |im| Im.create im.merge!(user_id: im['user']) }
    end

    def self.models
      %w(Channel SlackUser Im).map { |model| "#{to_s}::#{model}".constantize }
    end
  end
end