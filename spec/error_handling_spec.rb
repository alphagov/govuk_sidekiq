require "spec_helper"
require "govuk_sidekiq/error_handling"

RSpec.describe GovukSidekiq::ErrorHandling::RetryWithoutAlertMiddleware do
  def worker
    raise GdsApi::HTTPClientError.new("oh no")
  end

  subject do
    described_class.new.call("worker", msg, "queue") { worker }
  end

  context "when the job is on the last attempt" do
    let(:msg) do
      {
        "retry" => 5,
        "retry_count" => 4,
      }
    end

    it "raises the real exception" do
      expect { subject }.to raise_error(GdsApi::HTTPClientError)
    end
  end

  context "when the job is not on the last attempt" do
    let(:msg) do
      {
        "retry" => 5,
        "retry_count" => 1,
      }
    end

    it "raises the retry exception" do
      expect { subject }.to raise_error(GovukSidekiq::ErrorHandling::RetryableError)
    end
  end

  context "when the job is not on the last attempt and it has the default max attempts" do
    let(:msg) do
      {
        "retry" => true,
        "retry_count" => 1,
      }
    end

    it "raises the retry exception" do
      expect { subject }.to raise_error(GovukSidekiq::ErrorHandling::RetryableError)
    end
  end
end
