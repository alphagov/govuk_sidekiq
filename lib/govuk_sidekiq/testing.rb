require "sidekiq/testing"

Sidekiq::Testing.server_middleware do |chain|
  chain.add GovukSidekiq::APIHeaders::ServerMiddleware
end
