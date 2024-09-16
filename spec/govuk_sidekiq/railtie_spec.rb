require "climate_control"
require "rails"
require "govuk_sidekiq/railtie"

RSpec.describe GovukSidekiq::Railtie do
  let(:app) { instance_double(Rails::Application, root: Pathname.new("rails/app")) }
  let(:default_redis_configuration) { { url: "redis://127.0.0.1:6379" } }

  before { ENV["REDIS_URL"] = "redis://127.0.0.1:6379" }

  it "initializes SidekiqInitializer with default options" do
    expect(GovukSidekiq::SidekiqInitializer)
      .to receive(:setup_sidekiq)
      .with(default_redis_configuration)

    described_class.initializers.first.run(app)
  end

  it "can set Redis URL via on an env var" do
    ClimateControl.modify REDIS_URL: "redis://redis" do
      expect(GovukSidekiq::SidekiqInitializer)
        .to receive(:setup_sidekiq)
        .with({ url: "redis://redis" })

      described_class.initializers.first.run(app)
    end
  end
end
