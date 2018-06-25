require 'rails_helper'
RSpec.describe SlackNotifierService do
  include SlackNotifierService
  context "check webhook for sending slack message" do
    it "should send message to specified slack channel" do
      VCR.use_cassette("send_slack_message") do
        a = send_message_on_slack_channel("test_new", "Test message")
        expect(a[0].code).to eq("200")
      end
    end
  end
end
