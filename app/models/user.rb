class User < ActiveRecord::Base
  def self.admin
    where(role: 'admin').first
  end
end
