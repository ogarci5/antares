class ReminderWorker
  @queue = :default

  def self.perform(task_id)
    Karen::Reminder.new(task_id).deliver
  end
end