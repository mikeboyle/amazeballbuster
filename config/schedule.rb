# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# set :environment, 'development'

every 2.minutes do
  rake "amazeballbuster:respond_to_tweets"
end

every 5.minutes do
  rake "amazeballbuster:bust"
end

every 3.hours do
  rake "amazeballbuster:clean_up_db"
end

every 15.minutes do
  rake "amazeballbuster:manage_followers"
end
