class Karen::Slack::Channel < Karen::Model::Base
  attr_accessible id: :id, name: :name, notify: :notify, display: :display
  set_settings :notify, :display

  attribute :name
  attribute :notify, ->(bool) { bool == 'true' }
  attribute :display, ->(bool) { bool == 'true' }

  index :notify
  index :display

  collection :messages, 'Karen::Slack::Message'

  scope :notify, -> { find notify: true }
  scope :display, -> { find display: true }

  def method
    'channels.history'
  end

  def to_s
    name.titleize
  end

  def display_name
    name.humanize.downcase
  end
end