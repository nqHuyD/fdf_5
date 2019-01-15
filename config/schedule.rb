set :output, "log/cron_log.log"
env :PATH, ENV["PATH"]
every 1.minutes do
  rake "send_static_to_admin", :environment => "development"
end
