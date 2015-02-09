module Karen
  class Reminder

    def initialize(task_id)
      @task = Task.find(task_id)
      @message = @task.goal[0, 1].downcase + @task.goal[1..-1]
      @user = User.admin
    end

    def set
      Resque.enqueue_at (@task.next_due_date - 10.minutes), ReminderWorker, @task.id
    end

    def deliver
      Resque.enqueue(SMSWorker, serialized_message)
    end

    def message
      '%s, please %s. Thank you -Karen' % [@user.first_name, @message]
    end

    def serialized_message
      {body: message, recipient: @user.phone_number}
    end
  end
end