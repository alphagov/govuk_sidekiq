module GovukSidekiq
  class Railtie < Rails::Railtie
    initializer "govuk_sidekiq.initialize_sidekiq" do |app|
      SidekiqInitializer.setup_sidekiq(
        ENV["GOVUK_APP_NAME"] || app.root.basename.to_s,
        ENV["REDIS_HOST"] || "127.0.0.1",
        ENV["REDIS_PORT"] || 6379
      )
    end
  end
end
