class Goal < ActiveRecord::Base
  has_many :tasks
  has_many :progresses

  default_scope ->{ order('priority DESC, due_date ASC') }

  scope :not_completed, ->{ where(completed: false) }

  def complete
    self.completed = true
    self.save
  end

  def uncomplete
    self.completed = false
    self.save
  end

  def past_due?
    self.due_date < Time.now
  end
end
