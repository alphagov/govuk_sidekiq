require "govuk_sidekiq/sidekiq_initializer"

RSpec.describe GovukSidekiq::SidekiqInitializer do
  it "doesn't explode when called" do
    described_class.setup_sidekiq("govuk_app_name", { url: "redis://redis" })
  end
end
