require "sidekiq/testing"
require "govuk_sidekiq/api_headers"

Sidekiq::Testing.server_middleware do |chain|
  chain.add GovukSidekiq::APIHeaders::ServerMiddleware
end
