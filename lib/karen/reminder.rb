module Karen
  class Reminder

    REMINDER_TIME_DEFAULTS = {
      daily: 1.hour, weekly: 1.day, monthly: 3.days,
      past_due: { daily: 3.hours, weekly: 1.day, monthly: 3.days }
    }

    def self.update_all
      completed_tasks, uncompleted_tasks = *Karen::Task.remindable.partition(&:completed?)
      completed_tasks.each { |task| Karen::Reminder.new(task.id).destroy_workers }
      uncompleted_tasks.each { |task| Karen::Reminder.new(task.id).set }
    end

    def self.destroy_all
      Resque.redis.zrangebyscore('Resque::Delayed:internal', '-inf', '+inf').each do |task|
        Resque.redis.zrem('Resque::Delayed:internal', task)
      end
    end

    def initialize(task_id)
      @task_id = task_id
      @task = Karen::Task.find(@task_id)
      @message = @task.description[0, 1].downcase + @task.description[1..-1]
      @user = User.admin
    end

    def unset?
      delayed_tasks = Resque.redis.zrangebyscore('Resque::Delayed:internal', '-inf', remind_time.to_i)
      delayed_tasks.none? {|task| task.include?('"ReminderWorker",%s,%s' % [@task_id, @task.updated_at.to_i])}
    end

    def destroy_workers
      delayed_tasks = Resque.redis.zrangebyscore('Resque::Delayed:internal', '-inf', remind_time.to_i)
      delayed_tasks.select {|task| task.include?('"ReminderWorker",%s' % @task_id)}.each do |task|
        Resque.redis.zrem('Resque::Delayed:internal', task)
      end
    end

    def set
      if self.unset? && @task.reminded_at != remind_time
        destroy_workers
        Resque.enqueue_at(remind_time, ReminderWorker, @task_id, @task.updated_at.to_i)
        @task.reminded_at = remind_time
        @task.save
      end
    end

    def deliver
      Resque.enqueue(SMSWorker, serialized_message)
      puts 'Reminder for Task %s has been sent' % @task_id
    end

    def message
      if @task.past_due?
        '%s, you must have forgotten to %s. Please take care of this. -Karen' % [@user.first_name, @message]
      else
        '%s, please %s. Thank you -Karen' % [@user.first_name, @message]
      end
    end

    def serialized_message
      {body: message, recipient: @user.phone_number}
    end

    def remind_time
      @task.past_due? ?
        (@task.due_date + REMINDER_TIME_DEFAULTS[:past_due][@task.period.downcase.to_sym]) :
        (@task.due_date - REMINDER_TIME_DEFAULTS[@task.period.downcase.to_sym])
    end
  end
end