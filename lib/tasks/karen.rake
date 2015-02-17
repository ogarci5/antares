namespace :karen do
  task start: :environment do
    Karen.initialize!
    Karen.client.start
  end
end