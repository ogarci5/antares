module Karen
  class Task

    def initialize(task_id)
      @task_id = task_id
    end

    def self.all
      Rails.cache.fetch('tasks') { ActiveRecord::Base::Task.all }
    end

    def self.remindable
      all.select(&:remind_me?)
    end

    def self.find(id)
      all.select{|task| task.id == id}.first
    end

    def self.uncomplete_all
      self.remindable.select(&:completed?).select(&:past_due?).each(&:uncomplete)
    end

  end
end