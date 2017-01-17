require "govuk_sidekiq/sidekiq_initializer"

module GovukSidekiq
  class Railtie < Rails::Railtie
    initializer "govuk_sidekiq.initialize_sidekiq" do |app|
      config = if ENV['REDIS_URL']
                 { url: ENV['REDIS_URL'] }
               else
                 {
                   host: ENV.fetch("REDIS_HOST", "127.0.0.1"),
                   port: ENV.fetch("REDIS_PORT", 6379)
                 }
               end

      SidekiqInitializer.setup_sidekiq(
        ENV["GOVUK_APP_NAME"] || app.root.basename.to_s,
        config
      )
    end
  end
end
