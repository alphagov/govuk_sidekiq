require "gds-sso"
require "govuk_sidekiq/gds_sso_middleware"

class TestUser
  include GDS::SSO::User
  def initialize
    @permissions = []
    @remotely_signed_out = false
  end

  attr_accessor :permissions

  def has_permission?(permission)
    permissions.include?(permission)
  end

  def remotely_signed_out?
    @remotely_signed_out
  end
end

RSpec.describe GovukSidekiq::GdsSsoMiddleware do
  let(:user) { TestUser.new }
  let(:warden) { instance_double(Warden::Proxy, user: user, authenticated?: true) }

  before do
    allow(warden).to receive(:authenticate!)
  end

  it "proxies a request to sidekiq web for an authenticated user with a 'Sidekiq Admin' permission" do
    user.permissions = [GovukSidekiq::GdsSsoMiddleware::SIDEKIQ_SIGNON_PERMISSION]
    env = { "warden" => warden }

    allow(Sidekiq::Web).to receive(:call).and_return([200, {}, %w[body]])

    described_class.call(env)

    expect(Sidekiq::Web).to have_received(:call).with(env)
  end

  it "returns a 403 forbidden response for an authenticated user without 'Sidekiq Admin' permission" do
    user.permissions = []

    status, _headers, body = described_class.call({ "warden" => warden })

    expect(status).to eq(403)
    expect(body).to eq(["Forbidden - access requires the \"#{described_class::SIDEKIQ_SIGNON_PERMISSION}\" permission"])
  end

  it "attempts to authenticate when a user is not authenticated" do
    allow(warden).to receive(:authenticated?).and_return(false)

    described_class.call({ "warden" => warden })

    expect(warden).to have_received(:authenticate!)
  end

  it "attempts to authenticate when a user is remotely signed out" do
    allow(user).to receive(:remotely_signed_out?).and_return(true)

    described_class.call({ "warden" => warden })

    expect(warden).to have_received(:authenticate!)
  end
end
