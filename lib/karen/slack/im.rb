class Karen::Slack::Im < Karen::Model::Base
  attr_accessible id: :id, user_id: :user_id, notify: :notify, display: :display
  set_settings :notify, :display

  attribute :notify, ->(bool) { bool == 'true' }
  attribute :display, ->(bool) { bool == 'true' }

  index :notify
  index :display

  collection :messages, 'Karen::Slack::Message'
  reference :user, 'Karen::Slack::SlackUser'

  scope :notify, -> { find notify: true }
  scope :display, -> { find display: true }

  def self.display_name
    'Instant Messages'
  end

  def method
    'im.history'
  end

  def to_s
    user.to_s
  end

  def name
    to_s
  end
end
