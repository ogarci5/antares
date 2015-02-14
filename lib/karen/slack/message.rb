module Karen
  module Slack
    class Message
      USER_MAPPING = {
        'U02AV65KL'=>'anton.domratchev', 'U030RK47R'=>'cmoel', 'U02990CTU'=>'jason.ellis', 'U0297QRT9'=>'jason_straughan',
        'U02CZ5W7K'=>'jeffreyjurgajtis', 'U02D2J0AB'=>'joseph.villafranca', 'U0298LAMH'=>'josh', 'U02B7DHJ7'=>'oliver.garcia'
      }
      CHANNELS = [{name: 'dynasty_owner', id: 'C02CQNP2C', method: 'channels.history', notify: true},
                  {name: 'general', id: 'C0297QRTF', method: 'channels.history', notify: false},
                  {name: 'direct_message', id: 'D02B7DHJT', method: 'im.history', notify: true}]

      class << self

        def update_all
          CHANNELS.each do |channel|
            messages = Slack::API.call(channel[:method], {channel: channel[:id], count: 20})
            if messages != retrieve(channel)
              Rails.cache.write("slack_channel_#{channel[:id]}", messages)
              Karen::Message.new(type: 'karen/slack').deliver if channel[:notify]
            end
          end
        end

        def retrieve(options = {})
          Rails.cache.fetch("slack_channel_#{options[:id]}") do
            Slack::API.call(options[:method], {channel: options[:id], count: 20})
          end
        end

        def all
          CHANNELS.map do |channel|
            messages = retrieve(channel)
            messages = messages['messages'].reverse.map do |msg|
              msg['user'] = USER_MAPPING[msg['user']]
              msg['ts'] = Time.at(msg['ts'].to_i)
              USER_MAPPING.each do |id, name|
                msg['text'] = msg['text'].gsub(id, name)
              end
              msg
            end
            channel.merge(messages: messages).with_indifferent_access
          end
        end

        # Scopes
        def today
          all.map do |channel|
            channel['messages'] = channel['messages'].select{|msg| msg['ts'] > Chronic.parse('yesterday at midnight')}
            channel
          end
        end
      end
    end
  end
end