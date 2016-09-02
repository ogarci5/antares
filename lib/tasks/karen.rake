namespace :karen do
  task start: :environment do
    Karen.initialize!
    puts "Initialized Karen"
    puts "Starting Karen"
    Karen.client.start
  end
end
