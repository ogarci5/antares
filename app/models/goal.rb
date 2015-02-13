class Goal < ActiveRecord::Base
  has_many :tasks
  has_many :progresses
end
