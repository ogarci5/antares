class ReminderWorker
  @queue = :default

  def self.perform(task_id, updated)
    Karen::Reminder.new(task_id).deliver
  end
end