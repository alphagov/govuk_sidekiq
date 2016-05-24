require "gem_publisher"
require "rake/testtask"
require "bundler"

desc "Run basic tests"
Rake::TestTask.new("test") do |t|
  t.libs << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  t.warning = true
end

desc "Publish gem to RubyGems"
task :publish_gem do |t|
  published_gem = GemPublisher.publish_if_updated("govuk_sidekiq.gemspec", :rubygems)
  puts "Published #{published_gem}" if published_gem
end

task :default => :test
