module Karen
  module Slack
    class Message < Karen::Model::Base
      attr_accessible id: :id, channel_id: :channel_id, im_id: :im_id, user_id: :user_id, text: :text, ts: :ts

      attribute :text
      attribute :ts

      reference :channel, 'Karen::Slack::Channel'
      reference :im, 'Karen::Slack::Im'
      reference :user, 'Karen::Slack::SlackUser'

      class << self
        def update_all
          update_channels
          update_ims
        end
        
        def update_channels
          Karen::Slack::Channel.display.to_a.each do |channel|
            messages = Karen::Slack::API.call(channel.method, {channel: channel.id, count: 20}).try(:[], 'messages') || []

            if messages.first.try(:[], 'ts') != channel.messages.to_a.last.try(:ts)
              messages.each do |message|
                next if self[[channel.id, message['ts']].join('_')]

                Karen::Slack::SlackUser.all.to_a.each do |user|
                  message['text'] = message['text'].try(:gsub, user.id, user.name)
                end

                msg = new id: [channel.id, message['ts']].join('_')
                msg.ts = message['ts'].to_f
                msg.channel_id = channel.id
                msg.user_id = message['user']
                msg.text = message['text']
                msg.save
              end

              Karen::Message.new(type: 'karen/slack', text: channel.name.humanize.downcase).deliver if channel.notify
            end
          end
        end
        
        def update_ims
          Karen::Slack::Im.display.to_a.each do |im|
            messages = Karen::Slack::API.call(im.method, {channel: im.id, count: 20}).try(:[], 'messages') || []

            if messages.first.try(:[], 'ts') != im.messages.to_a.last.try(:ts)
              messages.each do |message|
                next if self[[im.id, message['ts']].join('_')]

                Karen::Slack::SlackUser.all.to_a.each do |user|
                  message['text'] = message['text'].try(:gsub, user.id, user.name)
                end

                msg = new id: [im.id, message['ts']].join('_')
                msg.ts = message['ts'].to_f
                msg.im_id = im.id
                msg.user_id = message['user']
                msg.text = message['text']
                msg.save
              end

              Karen::Message.new(type: 'karen/slack', text: im.to_s).deliver if im.notify
            end
          end
        end
      end

      def time
        Time.at ts.to_i
      end
    end
  end
end
