set :environment, "production"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

#every "*/1 * * * *" do
#   rake "jobs:work"
# end

every :reboot do
  rake "jobs:work"
end

every 1.minutes do
   rake "jobs:work"
end

every 1.weeks do
   rake "jobs:clear"
end