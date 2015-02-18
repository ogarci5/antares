class ReminderWorker
  @queue = :default

  def self.perform(task_id, updated)
    Karen.initialize!
    Karen::Reminder.new(task_id).send
  end
end