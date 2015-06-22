# This file configures what the client should be running
Karen.client = Karen::Client.new

Karen.client.configure do |config|

  config.run_every(60.seconds) do
    Karen::Task.uncomplete_all
    Karen::Reminder.update_all
  end

  #config.run_every(3.minutes) { Karen::Slack::Message.update_all }
end