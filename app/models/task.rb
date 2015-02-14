class Task < ActiveRecord::Base
  has_many :sub_tasks, class_name: 'Task', foreign_key: 'task_id'
  belongs_to :owner, class_name: 'Task', foreign_key: 'task_id'

  default_scope ->{ order('priority DESC, due_date ASC') }

  scope :sub_tasks, ->{ where.not(task_id: nil) }
  scope :recurring, ->{ where(recurring: true) }
  scope :not_completed, ->{ where(completed: false) }
  scope :today, ->{ where('due_date < ?', Chronic.parse('tomorrow')).reorder('due_date ASC') }
  scope :this_week, ->{ where('due_date < ?', Chronic.parse('next monday')) }

  after_commit :update_cache

  def complete
    self.completed = true
    self.completed_at = Time.now
    self.due_date = self.next_due_date
    self.save
  end

  def uncomplete
    self.completed = false
    self.completed_at = nil
    self.save
  end

  def past_due?
    self.due_date < Time.now
  end

  def next_due_date
    case self.period
      when 'daily'
        Chronic.parse("tomorrow at #{self.due_date.strftime('%H:%M%P')}", now: self.due_date)
      when 'weekly'
        Chronic.parse("next #{self.due_date.strftime('%A')} at #{self.due_date.strftime('%H:%M%P')}", now: self.due_date)
      when 'monthly'
        Chronic.parse("next month at #{self.due_date.strftime('%H:%M%P')}", now: self.due_date)
    end
  end

  private
  def update_cache
    Rails.cache.write('tasks', Task.all)
  end
end