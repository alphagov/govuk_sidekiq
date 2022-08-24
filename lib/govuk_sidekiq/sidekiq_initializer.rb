require "sidekiq"
require "sidekiq/logging/json"
require "sidekiq-statsd"
require "govuk_sidekiq/api_headers"
require "govuk_app_config/govuk_statsd"

module GovukSidekiq
  module SidekiqInitializer
    def self.setup_sidekiq(govuk_app_name, redis_config = {})
      redis_config = redis_config.merge(
        namespace: govuk_app_name,
        reconnect_attempts: 1,
      )

      Sidekiq.configure_server do |config|
        config.redis = redis_config

        config.server_middleware do |chain|
          chain.add Sidekiq::Statsd::ServerMiddleware, statsd: GovukStatsd, env: nil, prefix: "workers"
          chain.add GovukSidekiq::APIHeaders::ServerMiddleware
        end
      end

      Sidekiq.configure_client do |config|
        config.redis = redis_config

        config.client_middleware do |chain|
          chain.add GovukSidekiq::APIHeaders::ClientMiddleware
        end
      end

      Sidekiq.logger.formatter = Sidekiq::Logging::Json::Logger.new if Sidekiq.options[:logfile]
    end
  end
end
