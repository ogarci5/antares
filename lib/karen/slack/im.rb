class Karen::Slack::Im < Karen::Model::Base
  schema :id, :is_im, :user, :created, :is_user_deleted, :notify

  def method
    'im.history'
  end
end