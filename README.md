# GOV.UK Sidekiq

Provides a unified set of configurations and behaviours when using Sidekiq
in GOV.UK applications.

## Features

What does `govuk_sidekiq` do for you?

1. Makes sure Sidekiq can connect to Redis correctly, using the default
  environment variables (these are set in [govuk-puppet](https://github.com/alphagov/govuk-puppet)).
2. Makes sure that the correct HTTP headers are passed on to [gds-api-adapters](https://github.com/alphagov/gds-api-adapters).
 This means that for each request a unique ID (`govuk_request_id`) will be passed on to downstream applications.
 [Read more about request tracing][req-tracing].
3. Makes sure that we use JSON logging, so that Sidekiq logs will end up
 properly in Kibana.
4. Sends activity stats to Statsd, so that you can make pretty graphs of activity
 in Grafana or Graphite. See the [Rummager dashboards for an example](https://grafana.publishing.service.gov.uk/dashboard/file/rummager_queues.json).

[req-tracing]: https://docs.publishing.service.gov.uk/manual/setting-up-request-tracing.html

## Installation (Rails only)

### 1. Add the gem

```ruby
# Gemfile
gem "govuk_sidekiq", "~> VERSION"
```

### 2. Add a Sidekiq config file

```yaml
# config/sidekiq.yml
---
:concurrency:  2
```

This file also allows you to configure queues with priority.
[See the Sidekiq wiki for available options](https://github.com/mperham/sidekiq/wiki/Advanced-Options).

### 3. Add a Procfile

This is what puppet uses to create the process.

```sh
# Procfile
worker: bundle exec sidekiq -C ./config/sidekiq.yml
```

### 4. Configure puppet

- Set a `REDIS_URL` environment variable. `GOVUK_APP_NAME` should also be
set, but this is already done by the default `govuk::app::config`.

    Apply redis variables for your app in [the default config](https://github.com/alphagov/govuk-puppet/blob/master/hieradata/common.yaml). For example:

    ```
    govuk::apps::your_app::redis_host: "%{hiera('sidekiq_host')}"
    govuk::apps::your_app::redis_port: "%{hiera('sidekiq_port')}"
    ```
- Make sure puppet creates and starts the Procfile worker.

There's no step-by-step guide for this, but [you can copy the config from collections-publisher](https://github.com/alphagov/govuk-puppet/blob/master/modules/govuk/manifests/apps/collections_publisher.pp).

### 5. Configure deployment scripts

Make sure you restart the worker after deploying by adding a hook to the [capistrano scripts in govuk-app-deployment](https://github.com/alphagov/govuk-app-deployment). Otherwise the worker will keep running old code.

```ruby
# your-application/config/deploy.rb
after "deploy:restart", "deploy:restart_procfile_worker"
```

### 6. Add your worker to the Procfile & Pinfile

This makes sure that your development environment behaves like production.

See the [Pinfile][] and [Procfile][] for examples.

[Pinfile]: https://github.com/alphagov/govuk-puppet/tree/master/development-vm/Pinfile
[Procfile]: https://github.com/alphagov/govuk-puppet/tree/master/development-vm/Procfile

### 7. Add app to sidekiq-monitoring

See the opsmanual for a step-by-step guide: [Add sidekiq-monitoring to your application][monitoring]

[monitoring]: https://docs.publishing.service.gov.uk/manual/setting-up-new-sidekiq-monitoring-app.html

### 8. Create some jobs

You can [use normal Sidekiq jobs](https://github.com/mperham/sidekiq/wiki/Getting-Started):

```ruby
# app/workers/hard_worker.rb
class HardWorker
  include Sidekiq::Worker
  def perform(name, count)
    # do something
  end
end
```

Note that the convention is to use `app/workers` as the directory for your workers.

## Testing

See [Sidekiq testing documentation](https://github.com/mperham/sidekiq/wiki/Testing)
on how to test Sidekiq workers.

Because of the way we use middleware, you may see errors that indicate that
your job is called with the wrong number of arguments. To set up testing
correctly, replace `require 'sidekiq/testing'` with:

```ruby
require 'govuk_sidekiq/testing'
```

## Licence

[MIT License](LICENCE)

## Versioning policy

See https://github.com/alphagov/styleguides/blob/master/rubygems.md#versioning
