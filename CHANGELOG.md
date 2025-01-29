# Changelog

## 9.0.5

* Remove obsolete Redis namespaces Rake task

## 9.0.4

* Allow clients to pass in own value for Redis reconnect_attempts
* Reduce Redis reconnection timeout from 15-60s to 0.05-5s

## 9.0.3

* Update dependencies

## 9.0.2

* Update dependencies

## 9.0.1

* Allow setting of Redis SSL `verify_mode` to none via environment variable

## 9.0.0

* Switch from using `redis` gem to `redis-client`
* BREAKING: Remove `redis-namespace` dependency and support for Redis namespaces
  * Run the `redis_namespace:remove_namespace` rake task immediately after upgrading to to this version, to retain existing queued jobs.
* BREAKING: Upgrade Sidekiq to version 7.0, follow these steps to upgrade:
  1. `Sidekiq::Worker` has been deprecated in Sidekiq 7. Replace all instances of `Sidekiq::Worker` with `Sidekiq::Job`, then rename/move your workers to be `app/sidekiq/MyJob.rb` instead of `app/workers/MyWorker.rb`.
  1. Remove the requirement for Sidekiq strict arguments from `config/initializers/sidekiq.rb`. This was added to include Sidekiq 7 strict arguments behaviour in Sidekiq 6, but is no longer needed to be explictly required, since this is now the default behaviour.
  1. If using `sidekiq-unique-jobs`, pin to < 8.0.8 until [a known issue](https://github.com/mhenrixon/sidekiq-unique-jobs/issues/846) is resolved.
  1. Make any changes required based on the information in the [Sidekiq 7 API migration guide](https://github.com/sidekiq/sidekiq/blob/main/docs/7.0-API-Migration.md).

## 8.0.1

* Fix support for `reconnect_attempts` not working with Redis 4.8 (which is required due to the sidekiq version specified)

## 8.0.0

* BREAKING: Drop support for Ruby 3.0. The minimum required Ruby version is now 3.1.4.
* Add support for Ruby 3.3.
* Update Redis reconnect attempt strategy to retry more times.

## 7.1.5

* Redefine sidekiq requirement so Bundler won't install 7.0.0.beta1

## 7.1.4

* Require sidekiq > 6.5.10 and < 7

## 7.1.3

* Fix Sidekiq requirement to ~> 6.5 so that Bundler won't install v7.0.0.beta1

## 7.1.2

* Allow newer non-major versions of Sidekiq

## 7.1.1

* Remove context adding logic from sidekiq client middleware

## 7.1.0

* Add govuk_request_id to Sidekiq::Context so it will be included in logging
* Introduce a GOV.UK Logging format which has a field structure similar to GOV.UK's Rails logstasher for consistent field names

## 7.0.0

* BREAKING: Drop support for Ruby 2.7
* BREAKING: Remove support for Statsd, as this is being [deprecated from `govuk_app_config` in a later release](https://github.com/alphagov/govuk_app_config/commit/71f4f2fa3871721e5c8140bcf73d683e09d8d7b2)

## 6.0.0

* BREAKING: Upgrades the underlying version of Sidekiq to version 6. Will require changes to logging strategy;

* Sidekiq arguments need to serialize safely to JSON otherwise [a warning is shown](https://github.com/mperham/sidekiq/blob/main/Changes.md#640)
* Logging to a file no longer supported, must use STDOUT or STDERR

## 5.0.0

* BREAKING: Redis is configured with REDIS_URL environment, the previous approach (REDIS_HOST and REDIS_PORT) is no longer supported.

## 4.0.0

* BREAKING: Set the required Ruby version to >= 2.6

## 3.0.5

* Pin sidekiq-statsd above 2.1.0 (so we get new metrics).

## 3.0.4

* Allow for newer versions of sidekiq-statsd (trial period).

## 3.0.3

* Only use JSON logging when a log file is specified

## 3.0.2

* Set the `request_id` even if the `govuk_authenticated_user` is missing, and vice versa.

## 3.0.1

* Do not add API middleware arguments if they already exist.

## 3.0.0

* BREAKING. Your statsd namespace will likely change with this version, to a
form of `govuk.app.<app_name>.<hostname>` unless you are already using
the `GOVUK_STATSD_PREFIX` environment variable for your statsd.

* Loosen dependencies, now supports and requires Sidekiq 5
* Introduce dependency on [govuk_app_config](https://github.com/alphagov/govuk_app_config)
* Use GovukStatsd as the statsd client for sidekiq-statsd

## 2.0.0

* BREAKING. Remove automatic integration with Airbrake, as we are moving to use Sentry. To keep using this gem with Airbrake you can still add the following to an initialiser:

```ruby
require 'airbrake'

Sidekiq.configure_server do |config|
  config.error_handlers << Proc.new { |ex, context_hash| Airbrake.notify(ex, context_hash) }
end
```

## 1.0.3

* Explicitly set `reconnect_attempts: 1` in client and server configuration,
  to fix Sidekiq regression.

## 1.0.2

* Upgrade to Sidekiq 4.2.8.

## 1.0.1

* Upgrade to Sidekiq 4.2.2.

## 1.0.0

* No changes. Version bump to indicate gem is stable.

## 0.0.4

* Add support for testing with `govuk_sidekiq/testing`

## 0.0.1

* Create a gem which automatically configures Sidekiq.

  This injects a Rails initializer which will
  automatically configure Sidekiq for 12 factor apps
  (i.e. apps that use environment variables to set
  their redis configuration).

  It includes our current optimal sidekiq configuration
  including Airbrake/Errbit, statsd, JSON logging,
  and passthrough of the `govuk_request_id`.
