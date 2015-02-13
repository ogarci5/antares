namespace :karen do
  task start: :environment do
    Karen::Client.start
  end
end