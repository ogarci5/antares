module Karen
  module Slack
    class Message < Karen::Model::Base
      attr_accessible id: :id, channel_id: :channel_id, im_id: :im_id, user_id: :user_id, text: :text, ts: :ts

      attribute :text
      attribute :ts, ->(time) { time.to_f.round(6) }

      reference :channel, 'Karen::Slack::Channel'
      reference :im, 'Karen::Slack::Im'
      reference :user, 'Karen::Slack::SlackUser'

      class << self
        def update_all
          update_all_from_models(Karen::Slack::Channel, Karen::Slack::Im)
        end
        
        def update_all_from_models(*models)
          models.each do |model|
            model.display.to_a.each do |channel|
              messages = Karen::Slack::API.messages(channel: channel)

              if messages.first.try(:[], 'ts').to_f > channel.messages.sort_by(:ts).to_a.last.try(:ts).to_f
                messages.each do |message|
                  id = get_id(channel_id: channel.id, ts: message['ts'])
                  next if self[id]
                  message['text'] = format_raw_text(message['text'])
                  create({
                    :id => id,
                    :ts => message['ts'],
                    channel.reference_id => channel.id,
                    :user_id => message['user'],
                    :text => message['text']
                  })
                end

                Karen::Notification::Message.generate(type: base_module, text: channel.display_name).deliver if channel.notify
              end
            end
          end
        end

        private

        def get_id(channel_id:, ts:)
          [channel_id, ts].join('_')
        end

        # Replaces ids in slack messages with the user's name
        def format_raw_text(text)
          Karen::Slack::SlackUser.all.to_a.each do |user|
            text = text.try(:gsub, user.id, user.name)
          end
          text
        end
      end

      def time
        Time.at ts.to_i
      end
    end
  end
end
