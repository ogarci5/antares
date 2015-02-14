module Karen
  class Client
    def self.start
      minutes = 0
      begin
        Karen::Task.uncomplete_all
        Karen::Reminder.update_all

        if minutes == 0
          Karen::Slack::Message.update_all
          minutes +=3
        else
          minutes -= 1
        end

        sleep 60
      end until false
    end
  end
end