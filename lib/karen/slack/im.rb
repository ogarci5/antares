class Karen::Slack::Im < Karen::Model::Base
  schema :id, :is_im, :user, :created, :is_user_deleted, :notify, :display

  set_settings [
                 { name: :notify, type: :boolean },
                 { name: :display, type: :boolean }
               ]

  scope :notify, -> { where notify: true }
  scope :display, -> { where display: true }

  def self.display_name
    'Instant Messages'
  end

  def method
    'im.history'
  end

  def raw_messages
    Rails.cache.fetch("slack_im_#{id}_raw_messages") do
      Karen::Slack::API.call(method, channel: id, count: 20)
    end
  end

  def messages
    return @messages if @messages.present?
    @messages = Rails.cache.fetch("slack_im_#{id}_messages") do
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
    Karen::Slack::User.find(user) || user
  end
end