class Task < ActiveRecord::Base
  has_many :sub_tasks, class_name: 'Task', foreign_key: 'task_id'
  belongs_to :owner, class_name: 'Task', foreign_key: 'task_id'

  default_scope ->{ order('priority DESC, due_date ASC') }

  scope :main, ->{ where(task_id: nil) }
  scope :not_main, ->{ where.not(task_id: nil) }

  before_create :set_last_completed_at

  def next_due_date
    case period
      when 'Daily' then last_completed_at + 1.day
      when 'Weekly' then last_completed_at + 1.week
      when 'Monthly' then last_completed_at + 1.month
      else last_completed_at
    end
  end

  def complete
    self.completed = true
    self.completed_at = Time.now
    self.save
    Karen::Reminder.new(self).set
  end

  def uncomplete
    self.completed = false
    self.save
  end

  private
  def set_last_completed_at
    self.last_completed_at ||= Time.now
  end
end
