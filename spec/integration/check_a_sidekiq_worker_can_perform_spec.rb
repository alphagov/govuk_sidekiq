require "govuk_sidekiq/testing"
require "govuk_sidekiq/sidekiq_initializer"

RSpec.describe "Check a Sidekiq Worker can perform" do
  before do
    GovukSidekiq::SidekiqInitializer.setup_sidekiq({})
  end

  it "can run the test worker" do
    expect {
      Sidekiq::Testing.fake! do
        TestWorker.perform_async(1)
        TestWorker.drain
      end
    }.not_to raise_error
  end
end

class TestWorker
  include Sidekiq::Worker

  def perform(arg)
    arg + 1
  end
end
