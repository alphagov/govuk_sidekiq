require "gds_api/govuk_headers"

module GovukSidekiq
  module APIHeaders
    # Client-side middleware runs before the pushing of the job to Redis and
    # allows you to modify/stop the job before it gets pushed.
    #
    # https://github.com/mperham/sidekiq/wiki/Middleware#client-side-middleware
    class ClientMiddleware
      def call(worker_class, job, queue, redis_pool)
        last_arg = job["args"].last

        if needs_headers(last_arg)
          job["args"] << header_arguments
        end

        yield
      end

      def header_arguments
        {
          authenticated_user: GdsApi::GovukHeaders.headers[:x_govuk_authenticated_user],
          request_id: GdsApi::GovukHeaders.headers[:govuk_request_id],
        }
      end

      def needs_headers(last_arg)
        has_args = last_arg.is_a?(Hash) && last_arg.symbolize_keys.keys.include?(:authenticated_user) && last_arg.symbolize_keys.keys.include?(:request_id)
        !has_args && header_arguments[:authenticated_user].present? && header_arguments[:request_id].present?
      end
    end

    # Server-side middleware runs 'around' job processing.
    #
    # https://github.com/mperham/sidekiq/wiki/Middleware#server-side-middleware
    class ServerMiddleware
      def call(worker, message, queue)
        last_arg = message["args"].last

        if last_arg.is_a?(Hash) && last_arg.keys.include?("request_id")
          message["args"].pop
          request_id = last_arg["request_id"]
          authenticated_user = last_arg["authenticated_user"]
          GdsApi::GovukHeaders.set_header(:govuk_request_id, request_id)
          GdsApi::GovukHeaders.set_header(:x_govuk_authenticated_user, authenticated_user)
        end

        yield
      end
    end
  end
end
