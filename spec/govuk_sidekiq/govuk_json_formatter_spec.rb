require "govuk_sidekiq/govuk_json_formatter"

RSpec.describe GovukSidekiq::GovukJsonFormatter do
  it "outputs a json value with govuk request id" do
    Sidekiq::Context.add("govuk_request_id", "another-unique-request-id")
    json_formatter = described_class.new
    my_msg = json_formatter.call("info", Time.new(2007, 11, 1, 15, 25, 0, "+09:00"), nil, "A Meaningful message")
    msg_hash = JSON.parse(my_msg)

    expect(msg_hash).to match(hash_including(
                                "pid" => anything,
                                "level" => anything,
                                "govuk_request_id" => "another-unique-request-id",
                                "message" => "A Meaningful message",
                                "@timestamp" => "2007-11-01T06:25:00.000Z",
                              ))
  end
end
