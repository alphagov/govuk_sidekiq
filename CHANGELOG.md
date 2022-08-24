# 5.0.0

* BREAKING: Redis is configured with REDIS_URL environment, the previous approach (REDIS_HOST and REDIS_PORT) is no longer supported.

# 4.0.0

* BREAKING: Set the required Ruby version to >= 2.6

# 3.0.5

* Pin sidekiq-statsd above 2.1.0 (so we get new metrics).

# 3.0.4

* Allow for newer versions of sidekiq-statsd (trial period).

# 3.0.3

* Only use JSON logging when a log file is specified

# 3.0.2

* Set the `request_id` even if the `govuk_authenticated_user` is missing, and vice versa.

# 3.0.1

* Do not add API middleware arguments if they already exist.

# 3.0.0

* BREAKING. Your statsd namespace will likely change with this version, to a
form of `govuk.app.<app_name>.<hostname>` unless you are already using
the `GOVUK_STATSD_PREFIX` environment variable for your statsd.

* Loosen dependencies, now supports and requires Sidekiq 5
* Introduce dependency on [govuk_app_config](https://github.com/alphagov/govuk_app_config)
* Use GovukStatsd as the statsd client for sidekiq-statsd

# 2.0.0

* BREAKING. Remove automatic integration with Airbrake, as we are moving to use Sentry. To keep using this gem with Airbrake you can still add the following to an initialiser:

```ruby
require 'airbrake'

Sidekiq.configure_server do |config|
  config.error_handlers << Proc.new { |ex, context_hash| Airbrake.notify(ex, context_hash) }
end
```

# 1.0.3

* Explicitly set `reconnect_attempts: 1` in client and server configuration,
  to fix Sidekiq regression.

# 1.0.2

* Upgrade to Sidekiq 4.2.8.

# 1.0.1

* Upgrade to Sidekiq 4.2.2.

# 1.0.0

* No changes. Version bump to indicate gem is stable.

# 0.0.4

* Add support for testing with `govuk_sidekiq/testing`

# 0.0.1

* Create a gem which automatically configures Sidekiq.

  This injects a Rails initializer which will
  automatically configure Sidekiq for 12 factor apps
  (i.e. apps that use environment variables to set
  their redis configuration).

  It includes our current optimal sidekiq configuration
  including Airbrake/Errbit, statsd, JSON logging,
  and passthrough of the `govuk_request_id`.
