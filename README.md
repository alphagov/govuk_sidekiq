# GOVUK Sidekiq

Provides a unified set of configurations and behaviours when using Sidekiq
in GOV.UK applications.

## Usage

### Testing

See [Sidekiq testing documentation](https://github.com/mperham/sidekiq/wiki/Testing)
on how to test Sidekiq workers.


Because of the way we use middleware, you may see errors that indicate that
your job is called with the wrong number invalid arguments. To set up testing
correctly, replace `require 'sidekiq/testing'` with:

```ruby
require 'govuk_sidekiq/testing'
```

## Technical documentation

When added to a Rails application, this gem uses a railtie to inject an
initializer configuring Sidekiq.

It includes our current optimal sidekiq configuration
including Airbrake/Errbit, statsd, JSON logging,
and passthrough of the `govuk_request_id`.

No other configuration is required other than the presence of the following
environment variables:

- **GOVUK_APP_NAME**, used for Redis and statsd namespacing.
- **REDIS_HOST**
- **REDIS_PORT**

This gem also assumes that the app has separately configured and required Airbrake/Errbit.

## Licence

[MIT License](LICENCE)

## Versioning policy

See https://github.com/alphagov/styleguides/blob/master/rubygems.md#versioning
