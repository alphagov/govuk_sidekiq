require "sidekiq"
require "govuk_sidekiq/api_headers"
require "govuk_sidekiq/govuk_json_formatter"

module GovukSidekiq
  module SidekiqInitializer
    def self.setup_sidekiq(redis_config = {})
      redis_config[:reconnect_attempts] ||= [0.05, 0.25, 1, 5]

      Sidekiq.configure_server do |config|
        # $real_stdout is defined by govuk_app_config and is used to point to
        # STDOUT as that redirects $stdout to actually be $stderr.
        # When govuk_app_config does this we need to use $real_stdout to output logs to STDOUT.
        # https://github.com/alphagov/govuk_app_config/blob/08fd9cf6a848615261b3cef021e34490ed72ee55/lib/govuk_app_config/govuk_logging.rb#L18-L24

        # rubocop:disable Style/GlobalVars
        config.logger = Sidekiq::Logger.new($real_stdout) if defined?($real_stdout)
        # rubocop:enable Style/GlobalVars
        config.logger.formatter = GovukSidekiq::GovukJsonFormatter.new if ENV["GOVUK_SIDEKIQ_JSON_LOGGING"]

        config.redis = redis_config

        config.server_middleware do |chain|
          chain.add GovukSidekiq::APIHeaders::ServerMiddleware
        end
      end

      Sidekiq.configure_client do |config|
        config.redis = redis_config

        config.client_middleware do |chain|
          chain.add GovukSidekiq::APIHeaders::ClientMiddleware
        end
      end
    end
  end
end
