# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "govuk_sidekiq/version"
require "pathname"

Gem::Specification.new do |spec|
  spec.name          = "govuk_sidekiq"
  spec.version       = GovukSidekiq::VERSION
  spec.authors       = ["Elliot Crosby-McCullough"]
  spec.email         = ["elliot.cm@gmail.com"]
  spec.summary       = "Provides standard setup and behaviour for Sidekiq in GOV.UK applications."
  spec.homepage      = "http://github.com/alphagov/govuk_sidekiq"
  spec.license       = "MIT"

  spec.files         = Dir.glob("lib/**/*") + %w(README.md LICENCE.txt)
  spec.test_files    = Dir.glob("test/**/*")
  spec.require_paths = ["lib"]

  spec.add_dependency "sidekiq", "~> 4.1"
  spec.add_dependency "sidekiq-statsd", "~> 0.1"
  spec.add_dependency "sidekiq-logging-json", "~> 0.0"
  spec.add_dependency "gds-api-adapters", ">= 19.1.0"
  spec.add_dependency "airbrake", ">= 3.1.0"

  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "rake", "~> 11.1"

  spec.add_development_dependency "bundler", ">= 1.10"
  spec.add_development_dependency "gem_publisher", "1.5.0"
end
