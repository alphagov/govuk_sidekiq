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

[req-tracing]: https://docs.publishing.service.gov.uk/manual/setting-up-request-tracing.html

## Installation (Rails only)

### 1. Add the gem

```ruby
# Gemfile
gem "govuk_sidekiq"
```

### 2. Add a Sidekiq config file

```yaml
# config/sidekiq.yml
---
:concurrency:  2
```

This file also allows you to configure queues with priority.
[See the Sidekiq wiki for available options](https://github.com/mperham/sidekiq/wiki/Advanced-Options).

### 3. Configure environment variables in EKS

For each environment ([integration](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-integration.yaml), [staging](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-staging.yaml) and [production](https://github.com/alphagov/govuk-helm-charts/blob/main/charts/app-config/values-production.yaml)), add a `REDIS_URL` environment variable for your application with a value of `redis://shared-redis-govuk.eks.{environment}.govuk-internal.digital`.

Additionally, set the value of `workerEnabled` to `true` for your application. This will [result in a `worker` process](https://github.com/alphagov/govuk-helm-charts/blob/8b008832b5e8f62f2f489d3b030be21945d2b08b/charts/generic-govuk-app/values.yaml#L16-L21) running alongside the web application. The queue length and max delay can be monitored using the [Sidekiq Grafana dashboard](https://grafana.eks.production.govuk.digital/d/sidekiq-queues), once the Sidekiq worker is initialised.

There's no step-by-step guide for this, but [you can copy the changes made when Sidekiq was added to the release application](https://github.com/alphagov/govuk-helm-charts/pull/1117/files). You may also want to [resize resource requests](https://github.com/alphagov/govuk-helm-charts/pull/1121/files) for the app depending on the predicted request rate. 

```ruby
# your-application/config/deploy.rb
after "deploy:restart", "deploy:restart_procfile_worker"
```

### 4. Create some jobs

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
