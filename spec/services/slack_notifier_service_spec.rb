require 'rails_helper'
RSpec.describe SlackNotifierService do
  include SlackNotifierService
  context "check webhook for sending slack message" do
    it "should send message to specified slack channel if channel name is valid" do
      VCR.use_cassette("send_slack_message") do
        a = send_message_on_slack_channel("test_new", "Test message")
        expect(a).to be(true)
      end
    end

    it "should not send message to specified slack channel if invalid" do
      VCR.use_cassette("not_send_slack_message") do
        a = send_message_on_slack_channel("test_failed", "Test message")
        expect(a).to be(false)
      end
    end
  end
end
