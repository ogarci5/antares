class Karen::Slack::Channel < Karen::Model::Base
  schema :id, :name, :is_channel, :created, :creator, :is_archived, :is_general, :is_member, :members, :topic,
         :purpose, :num_members, :notify, :display

  set_settings [
    { name: :notify, type: :boolean },
    { name: :display, type: :boolean }
  ]

  scope :notify, -> { where notify: true }
  scope :display, -> { where display: true }

  def method
    'channels.history'
  end

  def raw_messages
    Rails.cache.fetch("slack_channel_#{id}_raw_messages") do
      Karen::Slack::API.call(method, channel: id, count: 20)
    end
  end

  def messages
    Rails.cache.fetch("slack_channel_#{id}_messages") do
      raw_messages['messages'].reverse.map do |msg|
        msg['user'] = Karen::Slack::User.find(msg['user']).try(:real_name)
        msg['ts'] = Time.zone.at(msg['ts'].to_i)
        Karen::Slack::User.all.each do |user|
          msg['text'] = msg['text'].try(:gsub, user.id, user.name)
        end
        msg
      end
    end
  end

  def to_s
    name.titleize
  end
end