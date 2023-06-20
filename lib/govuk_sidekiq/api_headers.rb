require "gds_api/govuk_headers"
require "sidekiq"

module GovukSidekiq
  module APIHeaders
    # Client-side middleware runs before the pushing of the job to Redis and
    # allows you to modify/stop the job before it gets pushed.
    #
    # https://github.com/mperham/sidekiq/wiki/Middleware#client-side-middleware
    class ClientMiddleware
      def call(_worker_class, job, _queue, _redis_pool)
        last_arg = job["args"].last

        if is_header_hash(last_arg)
          job["args"].pop
          job["args"] << header_arguments.merge(last_arg)
        else
          job["args"] << header_arguments
        end
        Sidekiq::Context.add("govuk_request_id", job["args"].last["request_id"])

        yield
      end

      def header_arguments
        {
          "authenticated_user" => GdsApi::GovukHeaders.headers[:x_govuk_authenticated_user],
          "request_id" => GdsApi::GovukHeaders.headers[:govuk_request_id],
        }
      end

      def is_header_hash(arg)
        arg.is_a?(Hash) && (arg.symbolize_keys.keys.include?(:authenticated_user) || arg.symbolize_keys.keys.include?(:request_id))
      end
    end

    # Server-side middleware runs 'around' job processing.
    #
    # https://github.com/mperham/sidekiq/wiki/Middleware#server-side-middleware
    class ServerMiddleware
      def call(_worker, message, _queue)
        last_arg = message["args"].last

        if last_arg.is_a?(Hash) && last_arg.keys.include?("request_id")
          message["args"].pop
          request_id = last_arg["request_id"]
          authenticated_user = last_arg["authenticated_user"]
          GdsApi::GovukHeaders.set_header(:govuk_request_id, request_id)
          GdsApi::GovukHeaders.set_header(:x_govuk_authenticated_user, authenticated_user)
          Sidekiq::Context.add("govuk_request_id", request_id)
        end

        yield
      end
    end
  end
end
