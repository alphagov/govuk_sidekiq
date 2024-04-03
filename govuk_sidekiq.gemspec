lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "govuk_sidekiq/version"
require "pathname"

Gem::Specification.new do |spec|
  spec.name          = "govuk_sidekiq"
  spec.version       = GovukSidekiq::VERSION
  spec.authors       = ["GOV.UK Dev"]
  spec.email         = ["govuk-dev@digital.cabinet-office.gov.uk"]
  spec.summary       = "Provides standard setup and behaviour for Sidekiq in GOV.UK applications."
  spec.homepage      = "http://github.com/alphagov/govuk_sidekiq"
  spec.license       = "MIT"

  spec.files         = Dir.glob("lib/**/*") + %w[README.md LICENCE]
  spec.test_files    = Dir.glob("test/**/*")
  spec.require_paths = %w[lib]

  spec.required_ruby_version = ">= 3.1.4"

  spec.add_dependency "gds-api-adapters", ">= 19.1.0"
  spec.add_dependency "govuk_app_config", ">= 1.1"
  spec.add_dependency "redis-namespace", "~> 1.6"
  spec.add_dependency "sidekiq", "~> 6.5", ">= 6.5.12"

  spec.add_development_dependency "climate_control", "~> 1.2"
  spec.add_development_dependency "railties", "~> 7"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "rubocop-govuk", "4.16.1"
end
