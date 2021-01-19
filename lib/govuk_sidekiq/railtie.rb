require "govuk_sidekiq/sidekiq_initializer"

module GovukSidekiq
  class Railtie < Rails::Railtie
    initializer "govuk_sidekiq.initialize_sidekiq" do |app|
      SidekiqInitializer.setup_sidekiq(
        ENV["GOVUK_APP_NAME"] || app.root.basename.to_s,
        { url: ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379") },
      )
    end
  end
end
