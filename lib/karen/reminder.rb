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
      @message = @task.name[0, 1].downcase + @task.name[1..-1]
      @period = @task.period.try(:downcase).try(:to_sym).presence || :weekly
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
      if unset? && @task.reminded_at != remind_time
        destroy_workers
        Resque.enqueue_at(remind_time, ReminderWorker, @task_id, @task.updated_at.to_i)
        @task.reminded_at = remind_time
        @task.save
      end
    end

    def remind_time
      if @task.past_due?
        @task.due_date + REMINDER_TIME_DEFAULTS[:past_due][@period]
      else
        @task.due_date - REMINDER_TIME_DEFAULTS[@period])
      end
    end

    def deliver
      Karen::Notification::Message.generate(type: 'reminder', text: @message).deliver
      puts 'Reminder for Task %s has been sent' % @task_id
    end
  end
end
