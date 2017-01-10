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
