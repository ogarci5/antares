module Karen
  module Slack
    class Message
      class << self
        def update_all
          update_channels
          update_ims
        end
        
        def update_channels
          Karen::Slack::Channel.all.each do |channel|
            messages = Slack::API.call(channel.method, {channel: channel.id, count: 20})
            if messages != channel.raw_messages
              Rails.cache.write("slack_channel_#{channel.id}_raw_messages", messages)
              Karen::Message.new(type: 'karen/slack', text: channel.name.humanize.downcase).deliver if channel.notify
            end
          end
        end
        
        def update_ims
          Karen::Slack::Im.all.each do |im|
            messages = Slack::API.call(im.method, {im: im.id, count: 20})
            if messages != im.raw_messages
              Rails.cache.write("slack_im_#{im.id}_raw_messages", messages)
              Karen::Message.new(type: 'karen/slack', text: im.name.humanize.downcase).deliver if im.notify
            end
          end
        end
      end
    end
  end
end
