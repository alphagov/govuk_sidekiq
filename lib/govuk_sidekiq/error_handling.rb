require "gds_api/exceptions"
require "sidekiq/job_retry"

module GovukSidekiq
  module ErrorHandling
    class RetryableError < StandardError; end

    class RetryWithoutAlertMiddleware
      DEFAULT_EXCEPTIONS = [
        GdsApi::HTTPClientError,
      ].freeze

      def initialize(extra_exceptions = [])
        @extra_exceptions = extra_exceptions
      end

      attr_reader :extra_exceptions

      def call(worker, msg, queue)
        yield
      rescue *exceptions_to_catch
        if should_raise_real_exception?(msg)
          raise
        else
          raise RetryableError
        end
      end

      def exceptions_to_catch
        DEFAULT_EXCEPTIONS + extra_exceptions
      end

      def does_retry?(msg)
        msg["retry"]
      end

      def max_retries(msg)
        if msg["retry"].is_a?(Integer)
          msg["retry"]
        else
          Sidekiq::JobRetry::DEFAULT_MAX_RETRY_ATTEMPTS
        end
      end

      def retry_count(msg)
        msg["retry_count"] || 0
      end

      def last_try?(msg)
        retry_count(msg) == max_retries(msg) - 1
      end

      def should_raise_real_exception?(msg)
        !does_retry?(msg) || last_try?(msg)
      end
    end
  end
end
