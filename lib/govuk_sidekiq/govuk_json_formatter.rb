require "sidekiq"
require "govuk_sidekiq/api_headers"

module GovukSidekiq
  class GovukJsonFormatter < Sidekiq::Logger::Formatters::Base
    def call(severity, time, _, message)
      hash = {
        "@timestamp": time.utc.iso8601(3),
        pid: ::Process.pid,
        tid: tid,
        level: severity,
        message: message,
        tags: %w[sidekiq],
      }
      ctx.each { |key, value| hash[key] = value unless hash[key] }
      Sidekiq.dump_json(hash) << "\n"
    end
  end
end
