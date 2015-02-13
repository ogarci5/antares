module Karen
  class Client
    def self.start
      begin
        Karen::Task.uncomplete_all
        Karen::Reminder.update_all

        sleep 60
      end until false
    end
  end
end