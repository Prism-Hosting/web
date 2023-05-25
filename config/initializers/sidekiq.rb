if Rails.env.production?
  url = "redis://#{ENV['REDIS_USERNAME']}:#{ENV['REDIS_PASSWORD']}@#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}"

  Sidekiq.configure_server do |config|
    config.redis = { url: url }
    config.average_scheduled_poll_interval = 5
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: url }
  end
end


Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = "config/schedule.yml"

    if File.exist?(schedule_file)
      Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
    end
  end
end
