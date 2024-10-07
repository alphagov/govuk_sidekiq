require "govuk_sidekiq/sidekiq_initializer"

module GovukSidekiq
  class Railtie < Rails::Railtie
    initializer "govuk_sidekiq.initialize_sidekiq" do
      redis_options = { url: ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379") }

      if ENV["REDIS_SSL_VERIFY_NONE"] == "true"
        redis_options[:ssl_params] = { verify_mode: OpenSSL::SSL::VERIFY_NONE }
      end

      SidekiqInitializer.setup_sidekiq(redis_options)
    end

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
