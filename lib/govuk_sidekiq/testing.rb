require "govuk_sidekiq/api_headers"

Sidekiq.testing!(:fake)

Sidekiq::Testing.server_middleware do |chain|
  chain.add GovukSidekiq::APIHeaders::ServerMiddleware
end
