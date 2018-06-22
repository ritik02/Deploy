require 'rails_helper'
RSpec.describe JiraApiServices  do
  include EncryptionHelper
  fixtures :users

  context "check api for valid jira token" do
    it "Should return TRUE when token is Valid'" do
      VCR.use_cassette("valid_jira_token") do
        actual = JiraApiServices.new(decrypt_access_token(users(:one).jira_token), users(:one).email).check_api_for_valid_token?
        expect(actual).to eq true
      end
    end

    it "Should return False when token is Valid'" do
      VCR.use_cassette("invalid_jira_token") do
        actual = JiraApiServices.new("invalid_token", users(:one).email).check_api_for_valid_token?
        expect(actual).to eq false
      end
    end
  end

end
