class Karen::Slack::User < Karen::Model::Base
  schema :id, :name, :deleted, :status, :color, :real_name, :tz, :tz_label, :tz_offset, :profile, :is_admin, :is_owner,
         :is_primary_owner, :is_restricted, :is_ultra_restricted, :is_bot, :has_files
  set_settings

  def to_s
    name.titleize
  end
end