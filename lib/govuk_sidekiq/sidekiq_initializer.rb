require "sidekiq"
require "sidekiq/logging/json"
require "sidekiq-statsd"
require "airbrake"
require "govuk_sidekiq/api_headers"

module GovukSidekiq
  module SidekiqInitializer
    def self.setup_sidekiq(govuk_app_name, redis_config)
      redis_config = redis_config.merge(namespace: govuk_app_name)

      Sidekiq.configure_server do |config|
        config.redis = redis_config
        config.error_handlers << Proc.new { |ex, context_hash| Airbrake.notify(ex, context_hash) }

        config.server_middleware do |chain|
          chain.add Sidekiq::Statsd::ServerMiddleware, env: "govuk.app.#{govuk_app_name}", prefix: "workers"
          chain.add GovukSidekiq::APIHeaders::ServerMiddleware
        end
      end

      Sidekiq.configure_client do |config|
        config.redis = redis_config

        config.client_middleware do |chain|
          chain.add GovukSidekiq::APIHeaders::ClientMiddleware
        end
      end

      Sidekiq.logger.formatter = Sidekiq::Logging::Json::Logger.new
    end
  end
end
