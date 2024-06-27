require "govuk_sidekiq/sidekiq_initializer"

RSpec.describe GovukSidekiq::SidekiqInitializer do
  it "doesn't error when called" do
    expect {
      described_class.setup_sidekiq("govuk_app_name", { url: "redis://redis" })
    }.not_to raise_error
  end
end
