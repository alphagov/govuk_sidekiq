require "govuk_sidekiq/sidekiq_initializer"

module GovukSidekiq
  class Railtie < Rails::Railtie
    initializer "govuk_sidekiq.initialize_sidekiq" do
      SidekiqInitializer.setup_sidekiq(
        { url: ENV.fetch("REDIS_URL", "redis://127.0.0.1:6379"), ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } },
      )
    end

    rake_tasks do
      path = File.expand_path(__dir__)
      Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
    end
  end
end
