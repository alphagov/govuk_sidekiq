require "spec_helper"
require "rails"
require "govuk_sidekiq/railtie"

RSpec.describe GovukSidekiq::Railtie do
  let(:test_app) do
    Class.new(Rails::Application) do
      config.root = File.dirname(__FILE__)
      config.eager_load = false

      Rails.logger = config.logger = Logger.new(nil)
    end
  end
  let(:app_name) { test_app.root.basename.to_s }

  it "loads the SidekiqInitializer with the default config" do
    expected_config = { url: "redis://127.0.0.1:6379" }
    expect(GovukSidekiq::SidekiqInitializer).to receive(:setup_sidekiq).with(app_name, expected_config)
    test_app.initialize!
  end

  context "when ENV contains REDIS_URL" do
    let(:redis_url) { double }
    before { stub_environment("REDIS_URL" => redis_url) }

    it "loads the SidekiqInitializer with the redis url" do
      expected_config = { url: redis_url }
      expect(GovukSidekiq::SidekiqInitializer).to receive(:setup_sidekiq).with(app_name, expected_config)
      test_app.initialize!
    end
  end

  def stub_environment(values)
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:fetch).and_call_original

    values.each do |key, value|
      allow(ENV).to receive(:[]).with(key).and_return(value)
      allow(ENV).to receive(:fetch).with(key, anything).and_return(value)
    end
  end
end
