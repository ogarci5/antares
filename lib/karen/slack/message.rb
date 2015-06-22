module Karen
  module Slack
    class Message
      class << self
        def update_all
          Karen::Slack::Channel.all.each do |channel|
            messages = Slack::API.call(channel.method, {channel: channel.id, count: 20})
            if messages != channel.raw_messages
              Rails.cache.write("slack_channel_#{channel.id}_raw_messages", messages)
              Karen::Message.new(type: 'karen/slack', text: channel.name.humanize.downcase).deliver if channel.notify
            end
          end
        end
      end
    end
  end
end
