begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

require "gem_publisher"
desc "Publish gem to RubyGems"
task :publish_gem do |t|
  published_gem = GemPublisher.publish_if_updated("govuk_sidekiq.gemspec", :rubygems)
  puts "Published #{published_gem}" if published_gem
end

task :default => :spec
