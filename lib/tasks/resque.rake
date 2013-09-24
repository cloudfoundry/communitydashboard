require 'resque/tasks'
require 'resque_scheduler/tasks'

namespace :resque do
  task 'setup' => :environment do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'

    Resque.schedule = YAML.load_file('config/resque_schedule.yml')
  end
end

