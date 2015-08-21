class Karen::Slack::SlackUser < Karen::Model::Base
  attr_accessible id: :id, name: :name, real_name: :real_name

  attribute :name
  attribute :real_name

  collection :ims, 'Karen::Slack::Im', :user

  def to_s
    name.try(:titleize)
  end
end