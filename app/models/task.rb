class Task < ActiveRecord::Base
  has_many :sub_tasks, class_name: 'Task', foreign_key: 'task_id'
  belongs_to :owner, class_name: 'Task', foreign_key: 'task_id'

  default_scope ->{ order('priority DESC, due_date ASC') }

  scope :sub_tasks, ->{ where.not(task_id: nil) }
  scope :recurring, ->{ where(recurring: true) }
  scope :not_completed, ->{ where(completed: false) }
  scope :today, ->{ where(due_date: (Chronic.parse('today at 0:00')..Chronic.parse('today at 23:59'))).reorder('due_date ASC') }
  scope :not_today, ->{ where('due_date >= ?', Chronic.parse('tomorrow at 0:00')).reorder('due_date ASC') }

  after_commit :update_cache

  def self.this_week
    if Time.zone.now.sunday?
      where(due_date: Chronic.parse('today at 0:00')..Chronic.parse('next saturday at 23:59')).reorder('due_date ASC')
    else
      where(due_date: Chronic.parse('last sunday at 0:00')..Chronic.parse('next saturday at 23:59')).reorder('due_date ASC')
    end
  end

  def complete
    self.completed = true
    self.completed_at = Time.now
    self.due_date = next_due_date if recurring?
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
    now = Chronic.parse("today at #{due_date.strftime('%H:%M%P')}")
    case self.period.downcase
      when 'daily'
        Chronic.parse("tomorrow at #{now.strftime('%H:%M%P')}", now: now)
      when 'weekly'
        Chronic.parse("next #{due_date.strftime('%A')} at #{now.strftime('%H:%M%P')}", now: now)
      when 'monthly'
        Chronic.parse("next month at #{now.strftime('%H:%M%P')}", now: now)
    end
  end

  private
  def update_cache
    Rails.cache.write('tasks', Task.all)
  end
end