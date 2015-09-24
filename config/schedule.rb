# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Learn more: http://github.com/javan/whenever

set :output, "#{path}/log/cron.log"

# Examples:

# Do something every 15 minutes
# every 15.minutes do
#   command "cd #{path} && coffee #{path}/scripts/scriptOne.coffee"
# end

# Do something every 2 hours
# every 2.hours do
#   command "cd #{path} && coffee #{path}/scripts/scriptTwo.coffee"
# end

# Do something every 4 days
# every 4.days do
#   command "cd #{path} && coffee #{path}/scripts/scriptThree.coffee"
# end

# After declaring your cron jobs here, run:

# $ cd MY_APP 
# $ bundle exec whenever
# $ whenever -i
# $ crontab -l