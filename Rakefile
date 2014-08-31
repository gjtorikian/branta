# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Branta::Application.load_tasks

task :server do
  `bundle exec rails s -p 5000`
end

task "resque:setup" do
  ENV['QUEUE'] = '*'
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"

namespace :deploy do
  desc 'Deploy the app'
  task :production do
    app = "branta-ghp"
    remote = "git@heroku.com:#{app}.git"

    system "heroku maintenance:on --app #{app}"
    system "git push #{remote} master"
    system "heroku run rake db:migrate --app #{app}"
    system "heroku maintenance:off --app #{app}"
  end
end

# Heroku hack to compile assets during slug compilation
task 'assets:precompile' do
  puts `rake assets:precompile`
end
