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

  PRIORITY_MAPPING = {low: 0..30, medium: 31..70, high: 71..100, very_high: 100..999}

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

    # If it's recurring, when we complete this, a "new" task is auto generated so then it's not completed
    if recurring?
      self.due_date = next_due_date
      self.completed = false
    end

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

  def priority_label
    PRIORITY_MAPPING.select {|_, range| range.include?(priority)}.keys.first
  end



  private
  def update_cache
    Rails.cache.write('tasks', Task.all)
  end
end