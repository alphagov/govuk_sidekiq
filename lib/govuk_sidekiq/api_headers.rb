require "gds_api/govuk_headers"

module GovukSidekiq
  module APIHeaders
    # Client-side middleware runs before the pushing of the job to Redis and
    # allows you to modify/stop the job before it gets pushed.
    #
    # https://github.com/mperham/sidekiq/wiki/Middleware#client-side-middleware
    class ClientMiddleware
      def call(worker_class, job, queue, redis_pool)
        job["args"] << { request_id: GdsApi::GovukHeaders.headers[:govuk_request_id] }
        yield
      end
    end

    # Server-side middleware runs 'around' job processing.
    #
    # https://github.com/mperham/sidekiq/wiki/Middleware#server-side-middleware
    class ServerMiddleware
      def call(worker, message, queue)
        last_arg = message["args"].last

        if last_arg.is_a?(Hash) && last_arg.keys == ["request_id"]
          message["args"].pop
          request_id = last_arg["request_id"]
          GdsApi::GovukHeaders.set_header(:govuk_request_id, request_id)
        end

        yield
      end
    end
  end
end
