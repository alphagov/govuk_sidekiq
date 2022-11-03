require "rails"
require "govuk_sidekiq/railtie"

RSpec.describe GovukSidekiq::Railtie do
  let(:app) { instance_double("Rails::Application", root: Pathname.new("rails/app")) }
  let(:default_app_name) { "app" }

  it "initializes SidekiqInitializer with default options" do
    expect(GovukSidekiq::SidekiqInitializer)
      .to receive(:setup_sidekiq)
      .with(default_app_name, { url: "redis://127.0.0.1:6379" })

    described_class.initializers.first.run(app)
  end

  context "when ENV contains REDIS_URL" do
    let(:redis_url) { double }
    before { stub_environment("REDIS_URL" => redis_url) }

    it "loads the SidekiqInitializer with the redis url" do
      expected_config = { url: redis_url }
      expect(GovukSidekiq::SidekiqInitializer)
        .to receive(:setup_sidekiq)
        .with(default_app_name, expected_config)

      described_class.initializers.first.run(app)
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
