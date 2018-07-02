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

    it "Should return False when token is Invalid'" do
      VCR.use_cassette("invalid_jira_token") do
        actual = JiraApiServices.new("invalid_token", users(:one).email).check_api_for_valid_token?
        expect(actual).to eq false
      end
    end
  end

  context "check api creating an issue" do
    it "Should create a new issue" do
      VCR.use_cassette("create_new_jira_issue") do
        actual = JiraApiServices.new(decrypt_access_token(users(:eleven).jira_token), users(:eleven).email).create_issue("New Issue",
          "Checklist link",users(:eleven).username)
          expect(actual["self"]).to eq "https://godeploy.atlassian.net/rest/api/2/issue/10021"
        end
      end
    end
end
