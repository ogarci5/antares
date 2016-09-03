# This file configures what the client should be running
Karen.client = Karen::Client.new

Karen.client.configure do |config|

  config.run_every(60.seconds) do
    puts 'Running Karen::Task.uncomplete_all'
    Karen::Task.uncomplete_all
    puts 'Running Karen::Reminder.update_all'
    Karen::Reminder.update_all
  end

  #config.run_every(3.minutes) { puts "Running Karen::Slack::Message.update_all"; Karen::Slack::Message.update_all }
  #config.run_every(1.hour) { puts "Running Karen::Runescape::Info.update_from_api!"; Karen::Runescape::Info.update_from_api! }
end
