require 'resque/tasks'
require 'resque-delayed/tasks'

task 'resque:setup' => :environment do
  ENV['QUEUE'] = 'default'
end